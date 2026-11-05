#!/usr/bin/env python3
"""Collect only current-log UI launch timings from one known simulator container.

Profiling is diagnostic: unavailable or rejected data never changes a test result.
The output directory must be absent or empty and dedicated to this phase.
"""
import argparse
import errno
import json
import math
import os
from pathlib import Path
import re
import stat
import subprocess
import uuid


MARKER = 'CI_UI_LAUNCH_TRACE '
MAX_PROFILE_BYTES = 64 * 1024
UUID_PATTERN = re.compile(r'[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}\Z')
STAGES = frozenset({
    'will_finish_begin', 'dependencies_ready', 'preferences_ready', 'fixtures_ready',
    'will_finish_end', 'did_finish_begin', 'did_finish_end', 'app_active',
    'initial_view_appeared',
})
PROFILE_PARTS = ('Library', 'Caches', 'IntrospectiveUILaunchProfiles')
DIRECTORY_FLAGS = os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW


class ProfileError(ValueError):
    """A fixed, artifact-safe reason code; never include source content."""


def require(condition, code):
    if not condition:
        raise ProfileError(code)


def normalized_uuid(value):
    require(isinstance(value, str) and UUID_PATTERN.fullmatch(value) is not None, 'invalid_trace_id')
    return str(uuid.UUID(value))


def number(value):
    try:
        return type(value) in (int, float) and math.isfinite(value)
    except OverflowError:
        return False


def strict_json(data):
    def pairs(values):
        result = {}
        for key, value in values:
            require(key not in result, 'duplicate_json_key')
            result[key] = value
        return result

    def constant(_):
        raise ProfileError('nonfinite_json_number')

    try:
        return json.loads(data, object_pairs_hook=pairs, parse_constant=constant)
    except ProfileError:
        raise
    except (ValueError, UnicodeError, RecursionError, OverflowError) as error:
        raise ProfileError('invalid_json') from error


def read_traces(log, errors):
    """Keep wrapper spelling for output; compare UUID identity without case."""
    traces, seen = [], set()
    try:
        with log.open(encoding='utf-8', errors='replace') as source:
            for line in source:
                if MARKER not in line:
                    continue
                try:
                    payload = line.partition(MARKER)[2].strip()
                    require(len(payload) <= MAX_PROFILE_BYTES, 'invalid_trace_marker')
                    trace = strict_json(payload)
                    require(isinstance(trace, dict) and set(trace) == {
                        'schema', 'traceID', 'startUptime', 'endUptime',
                    }, 'invalid_trace_marker')
                    require(type(trace['schema']) is int and trace['schema'] == 1, 'invalid_trace_marker')
                    identity = normalized_uuid(trace['traceID'])
                    require(number(trace['startUptime']) and number(trace['endUptime']) and
                            0 <= trace['startUptime'] <= trace['endUptime'], 'invalid_trace_marker')
                    require(identity not in seen, 'duplicate_trace_id')
                except (ProfileError, OverflowError):
                    errors.append({'code': 'invalid_trace_marker'})
                    continue
                seen.add(identity)
                traces.append(trace['traceID'])
    except OSError:
        errors.append({'code': 'log_unavailable'})
    if not traces:
        errors.append({'code': 'no_trace_markers'})
    return traces


def app_container(simulator):
    normalized_uuid(simulator)
    try:
        result = subprocess.run(
            ['xcrun', 'simctl', 'get_app_container', simulator, 'com.bnova.Introspective', 'data'],
            capture_output=True, text=True, timeout=15, check=False,
        )
    except (OSError, subprocess.SubprocessError, UnicodeError) as error:
        raise ProfileError('container_unavailable') from error
    require(result.returncode == 0, 'container_unavailable')
    value = result.stdout.strip()
    require(value and len(value) < 4096 and not any(c in value for c in '\r\n\x00'),
            'invalid_container_path')
    path = Path(value)
    require(path.is_absolute() and '..' not in path.parts, 'invalid_container_path')
    return path


def profile_directory(container):
    """Open each descendant without following links, retaining only this directory."""
    descriptor = None
    try:
        descriptor = os.open(container, DIRECTORY_FLAGS)
        for part in PROFILE_PARTS:
            child = os.open(part, DIRECTORY_FLAGS, dir_fd=descriptor)
            os.close(descriptor)
            descriptor = child
        return descriptor
    except OSError as error:
        if descriptor is not None:
            os.close(descriptor)
        code = 'profile_directory_unsafe' if error.errno in (errno.ELOOP, errno.ENOTDIR) else 'profile_directory_unavailable'
        raise ProfileError(code) from error


def read_profile(directory, trace_id):
    # UUID.uuidString uses uppercase. Case variants support equivalent wrapper
    # IDs without enumerating app files or accepting arbitrary path components.
    candidates = dict.fromkeys((trace_id, trace_id.upper(), trace_id.lower()))
    descriptor = None
    try:
        identity = None
        for spelling in candidates:
            candidate = None
            try:
                candidate = os.open(spelling + '.json', os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK,
                                    dir_fd=directory)
                information = os.fstat(candidate)
                require(stat.S_ISREG(information.st_mode) and information.st_nlink == 1, 'profile_file_unsafe')
                require(information.st_size <= MAX_PROFILE_BYTES, 'profile_too_large')
                candidate_identity = (information.st_dev, information.st_ino)
                if descriptor is None:
                    descriptor, identity = candidate, candidate_identity
                    candidate = None
                else:
                    # Case-insensitive filesystems can open the same file through
                    # every spelling. Distinct files are ambiguous even if their
                    # contents happen to match; never choose a preferred spelling.
                    require(candidate_identity == identity, 'profile_file_ambiguous')
            except FileNotFoundError:
                continue
            except OSError as error:
                raise ProfileError('profile_file_unsafe') from error
            finally:
                if candidate is not None:
                    os.close(candidate)
        require(descriptor is not None, 'profile_missing')
        data = bytearray()
        while len(data) <= MAX_PROFILE_BYTES:
            block = os.read(descriptor, min(8192, MAX_PROFILE_BYTES + 1 - len(data)))
            if not block:
                break
            data.extend(block)
        require(len(data) <= MAX_PROFILE_BYTES, 'profile_too_large')
    finally:
        if descriptor is not None:
            os.close(descriptor)
    profile = strict_json(data)
    require(isinstance(profile, dict) and set(profile) == {'schema', 'traceID', 'stages'}, 'invalid_profile_schema')
    require(type(profile['schema']) is int and profile['schema'] == 1, 'invalid_profile_schema')
    require(normalized_uuid(profile['traceID']) == normalized_uuid(trace_id), 'profile_trace_id_mismatch')
    stages = profile['stages']
    require(isinstance(stages, dict) and set(stages) <= STAGES, 'invalid_profile_stages')
    require(all(number(value) and value >= 0 for value in stages.values()), 'invalid_profile_stages')
    # Reconstruct the exact allowlist; never copy original bytes or extra metadata.
    return {'schema': 1, 'traceID': trace_id, 'stages': {key: stages[key] for key in sorted(stages)}}


def output_directory(output, container):
    if container is not None:
        resolved, source = output.resolve(), container.resolve()
        require(resolved != source and source not in resolved.parents and resolved not in source.parents,
                'output_overlaps_app_container')
    require(not output.is_symlink(), 'output_directory_unsafe')
    try:
        output.mkdir(parents=True, exist_ok=True)
        descriptor = os.open(output, DIRECTORY_FLAGS)
        try:
            require(not os.listdir(descriptor), 'output_directory_not_empty')
        except BaseException:
            os.close(descriptor)
            raise
        return descriptor
    except OSError as error:
        raise ProfileError('output_directory_unavailable') from error


def atomic_json(directory, filename, value):
    data = (json.dumps(value, allow_nan=False, sort_keys=True, indent=2) + '\n').encode()
    temporary = '.ui-launch-' + uuid.uuid4().hex
    descriptor = None
    try:
        descriptor = os.open(temporary, os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW,
                             0o600, dir_fd=directory)
        with os.fdopen(descriptor, 'wb') as destination:
            descriptor = None
            destination.write(data)
            destination.flush()
            os.fsync(destination.fileno())
        os.replace(temporary, filename, src_dir_fd=directory, dst_dir_fd=directory)
    finally:
        if descriptor is not None:
            os.close(descriptor)
        try:
            os.unlink(temporary, dir_fd=directory)
        except FileNotFoundError:
            pass


def collect(simulator, workers, log, output):
    errors = []
    requested = read_traces(log, errors)
    status = {'schema': 1, 'availability': 'unavailable', 'workers': workers,
              'requested': requested, 'copied': [], 'missing': list(requested), 'errors': errors}
    if workers == 2:
        status['notes'] = ['Parallel worker clone containers are not resolved; collection covers only the supplied simulator.']
    container, source, destination = None, None, None
    try:
        if requested:
            try:
                require(bool(simulator), 'simulator_unavailable')
                container = app_container(simulator)
                source = profile_directory(container)
            except (ProfileError, OSError) as error:
                errors.append({'code': str(error) if isinstance(error, ProfileError) else 'profile_directory_unavailable'})
        destination = output_directory(output, container)
        if source is not None:
            for trace_id in requested:
                try:
                    profile = read_profile(source, trace_id)
                    atomic_json(destination, trace_id + '.json', profile)
                    status['copied'].append(trace_id)
                except (ProfileError, OSError, OverflowError) as error:
                    errors.append({'code': str(error) if isinstance(error, ProfileError) else 'profile_io_error',
                                   'traceID': trace_id})
        status['missing'] = [value for value in requested if value not in status['copied']]
        if status['copied']:
            status['availability'] = 'complete' if not status['missing'] and not errors and workers == 1 else 'partial'
        atomic_json(destination, 'collection-status.json', status)
    except (ProfileError, OSError, RuntimeError) as error:
        status['availability'] = 'partial' if status['copied'] else 'unavailable'
        errors.append({'code': str(error) if isinstance(error, ProfileError) else 'output_unavailable'})
    finally:
        if source is not None:
            os.close(source)
        if destination is not None:
            os.close(destination)
    return status


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--simulator', required=True, help='Known simulator UUID, or an empty string after early failure')
    parser.add_argument('--workers', required=True, type=int, choices=(1, 2))
    parser.add_argument('--log', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path, help='Absent or empty phase-specific artifact directory')
    args = parser.parse_args()
    status = collect(args.simulator, args.workers, args.log, args.output)
    print('UI launch profile collection: ' + json.dumps(status, allow_nan=False, sort_keys=True))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
