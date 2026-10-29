import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import time
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / 'create-git-version-swift-file.sh'


class GitVersionGeneration(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        (self.root / 'scripts').mkdir()
        (self.root / 'Common/Common').mkdir(parents=True)
        self.script = self.root / 'scripts' / SCRIPT.name
        shutil.copy(SCRIPT, self.script)
        (self.root / '.gitignore').write_text('Common/Common/GitVersion.swift\n')
        (self.root / 'source.swift').write_text('original')
        self.git('init', '-q')
        self.git('config', 'user.email', 'ci-tests@example.invalid')
        self.git('config', 'user.name', 'CI test')
        self.git('add', '.')
        self.git('commit', '-qm', 'Fixture')
        self.output = self.root / 'Common/Common/GitVersion.swift'

    def git(self, *arguments):
        return subprocess.check_output(['git', '-C', str(self.root), *arguments], stderr=subprocess.STDOUT).decode().strip()

    def generate(self):
        # The caller need not be inside this repository.
        subprocess.run(['bash', str(self.script)], cwd='/', check=True, capture_output=True)

    def test_repeat_generation_preserves_unchanged_content_and_timestamp(self):
        self.generate()
        content = self.output.read_text()
        self.assertIn(self.git('rev-parse', '--short=7', 'HEAD'), content)
        self.assertIn('UNCOMMITTED_CHANGES = false', content)
        stamp = time.time_ns() - 10_000_000_000
        os.utime(self.output, ns=(stamp, stamp))
        self.generate()
        self.assertEqual(self.output.read_text(), content)
        self.assertEqual(self.output.stat().st_mtime_ns, stamp)

    def test_tracked_edits_and_new_commits_update_version_contents(self):
        self.generate()
        first = self.output.read_text()
        (self.root / 'source.swift').write_text('changed')
        self.generate()
        self.assertIn('UNCOMMITTED_CHANGES = true', self.output.read_text())
        self.git('add', 'source.swift')
        self.git('commit', '-qm', 'Changed')
        self.generate()
        self.assertNotEqual(first, self.output.read_text())
        self.assertIn(self.git('rev-parse', '--short=7', 'HEAD'), self.output.read_text())
        self.assertIn('UNCOMMITTED_CHANGES = false', self.output.read_text())

    def test_untracked_files_do_not_change_the_version_flag(self):
        self.generate()
        first = self.output.read_text()
        (self.root / 'scratch.txt').write_text('temporary')
        self.generate()
        self.assertEqual(self.output.read_text(), first)
