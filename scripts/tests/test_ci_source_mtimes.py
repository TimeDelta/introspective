import importlib.util
import os
from pathlib import Path
import tempfile
import time
import unittest

spec = importlib.util.spec_from_file_location('source_times', Path(__file__).resolve().parents[1] / 'ci-source-mtimes.py')
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class SourceTimestampCache(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.path = self.root / 'source.swift'
        self.path.write_text('let value = 1')
        self.original = time.time_ns() - 10_000_000_000
        os.utime(self.path, ns=(self.original, self.original))
        self.manifest = module.snapshot(self.root, ['source.swift'])

    def test_only_identical_content_restores_checkout_timestamp(self):
        os.utime(self.path, None)
        self.assertEqual(module.restore(self.root, self.manifest, ['source.swift']), 1)
        self.assertEqual(self.path.stat().st_mtime_ns, self.original)
        self.path.write_text('let value = 2')  # Same size, different source.
        changed_time = self.path.stat().st_mtime_ns
        self.assertEqual(module.restore(self.root, self.manifest, ['source.swift']), 0)
        self.assertEqual(self.path.stat().st_mtime_ns, changed_time)
        self.assertEqual(self.path.read_text(), 'let value = 2')

    def test_changed_content_with_old_timestamp_forces_rebuild(self):
        self.path.write_text('let value = 2')
        os.utime(self.path, ns=(self.original, self.original))
        self.assertEqual(module.restore(self.root, self.manifest, ['source.swift']), 0)
        self.assertGreater(self.path.stat().st_mtime_ns, self.original)

    def test_malformed_or_incompatible_manifest_never_changes_timestamps(self):
        os.utime(self.path, None)
        current = self.path.stat().st_mtime_ns
        for manifest in [{}, dict(self.manifest, schema=2), dict(self.manifest, workspace='/other'),
                         dict(self.manifest, files={'source.swift': {'sha256': 'x' * 64, 'mtimeNS': True}})]:
            self.assertEqual(module.restore(self.root, manifest, ['source.swift']), 0)
            self.assertEqual(self.path.stat().st_mtime_ns, current)

    def test_paths_outside_checkout_and_symlinks_are_never_touched(self):
        outside = self.root.parent / (self.root.name + '-outside.swift')
        outside.write_text('outside')
        self.addCleanup(outside.unlink)
        (self.root / 'link.swift').symlink_to(outside)
        stamp = outside.stat().st_mtime_ns
        names = ['../' + outside.name, str(outside), 'link.swift']
        self.assertEqual(module.snapshot(self.root, names)['files'], {})
        malicious = dict(self.manifest, files={name: self.manifest['files']['source.swift'] for name in names})
        self.assertEqual(module.restore(self.root, malicious, names), 0)
        self.assertEqual(outside.stat().st_mtime_ns, stamp)
        self.assertEqual(outside.read_text(), 'outside')

    def test_added_deleted_and_unlisted_files_are_not_given_cached_times(self):
        self.path.unlink()
        new = self.root / 'new.swift'
        new.write_text('new source')
        stamp = new.stat().st_mtime_ns
        self.assertEqual(module.restore(self.root, self.manifest, ['source.swift', 'new.swift']), 0)
        self.assertEqual(new.stat().st_mtime_ns, stamp)
        self.assertFalse(self.path.exists())
