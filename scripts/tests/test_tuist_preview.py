"""Regression checks for upload selection, bundle versions and failure handling."""

import importlib.util
import json
from pathlib import Path
import plistlib
import subprocess
import tempfile
import unittest
from unittest.mock import patch


spec = importlib.util.spec_from_file_location("tuist_preview", Path(__file__).parents[1] / "tuist-preview.py")
preview = importlib.util.module_from_spec(spec)
spec.loader.exec_module(preview)


class PreviewTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.app = self.root / "Mulimi.app"
        for path, identifier, platform in (
            (self.app, "gaeng2y.DrinkWater", "iPhoneSimulator"),
            (self.app / "PlugIns/WidgetExtension.appex", "gaeng2y.DrinkWater.WidgetExtension", "iPhoneSimulator"),
            (self.app / "Watch/MulimiWatch.app", "gaeng2y.DrinkWater.watchkitapp", "WatchSimulator"),
        ):
            path.mkdir(parents=True)
            info = {
                "CFBundleIdentifier": identifier,
                "CFBundleVersion": "123.1",
                "CFBundleShortVersionString": "2.6.0",
                "CFBundleExecutable": "binary",
                "CFBundleSupportedPlatforms": [platform],
            }
            (path / "Info.plist").write_bytes(plistlib.dumps(info))
            (path / "binary").touch()
        (self.app / "Assets.car").touch()
        for name in ("Localization", "DesignSystemFoundation", "MulimiUISystem"):
            framework = self.app / "Frameworks" / f"{name}.framework"
            framework.mkdir(parents=True)
            (framework / name).touch()

    def change_plist(self, relative, **changes):
        path = self.app / relative / "Info.plist"
        info = plistlib.loads(path.read_bytes())
        path.write_bytes(plistlib.dumps({**info, **changes}))

    def test_verifies_all_embedded_bundles(self):
        self.assertEqual(preview.verify_app(self.app, "123.1"), "2.6.0")

    def test_rejects_stale_watch_and_widget_versions(self):
        for relative in ("Watch/MulimiWatch.app", "PlugIns/WidgetExtension.appex"):
            with self.subTest(bundle=relative):
                self.change_plist(relative, CFBundleVersion="37")
                with self.assertRaisesRegex(ValueError, "build number"):
                    preview.verify_app(self.app, "123.1")
                self.change_plist(relative, CFBundleVersion="123.1")

    def test_rejects_device_build(self):
        self.change_plist(".", CFBundleSupportedPlatforms=["iPhoneOS"])
        with self.assertRaisesRegex(ValueError, "iPhoneSimulator"):
            preview.verify_app(self.app, "123.1")

    def test_rejects_missing_resources(self):
        (self.app / "Assets.car").unlink()
        with self.assertRaisesRegex(ValueError, "assets"):
            preview.verify_app(self.app, "123.1")

    def test_reruns_receive_a_different_build_number(self):
        env = {"GITHUB_ACTIONS": "true", "GITHUB_RUN_NUMBER": "123", "GITHUB_RUN_ATTEMPT": "1"}
        self.assertEqual(preview.build_number(env), "123.1")
        self.assertEqual(preview.build_number({**env, "GITHUB_RUN_ATTEMPT": "2"}), "123.2")

    def test_rejects_missing_ci_attempt_and_invalid_override(self):
        with self.assertRaises(KeyError):
            preview.build_number({"GITHUB_ACTIONS": "true", "GITHUB_RUN_NUMBER": "123"})
        for value in ("1\n2", "one", "1.2.3.4", "1/2"):
            with self.subTest(value=value), self.assertRaises(ValueError):
                preview.build_number({"PREVIEW_BUILD_NUMBER": value})

    def test_no_success_link_on_invalid_upload_response(self):
        summary = self.root / "summary.md"
        for response in ({}, {"url": "https://example.com/preview"}, {"url": "file:///tmp/preview"}):
            with self.subTest(response=response), self.assertRaises(ValueError):
                preview.publish_result(response, {}, self.root, {"GITHUB_STEP_SUMMARY": str(summary)})
        self.assertFalse(summary.exists())
        self.assertFalse((self.root / "preview.json").exists())

    def test_summary_reports_built_commit_and_version(self):
        summary = self.root / "summary.md"
        metadata = {"commit": "abc123", "version": "2.6.0", "buildNumber": "123.2"}
        url = "https://tuist.dev/gaeng2y/mulimi/previews/preview-id"
        preview.publish_result({"url": url}, metadata, self.root, {"GITHUB_STEP_SUMMARY": str(summary)})
        self.assertIn(url, summary.read_text())
        self.assertIn("abc123", summary.read_text())
        self.assertIn("123.2", summary.read_text())
        self.assertEqual(json.loads((self.root / "preview.json").read_text())["url"], url)

    def test_failed_build_never_uploads(self):
        with patch.object(preview, "ROOT", self.root), \
                patch.dict(preview.os.environ, {}, clear=True), \
                patch("sys.argv", ["tuist-preview.py", "share"]), \
                patch.object(preview, "run") as run, \
                patch.object(preview, "build", side_effect=subprocess.CalledProcessError(65, "xcodebuild")):
            with self.assertRaises(subprocess.CalledProcessError):
                preview.main()
        self.assertEqual(run.call_args_list[0].args, ("tuist", "project", "show", preview.FULL_HANDLE))
        self.assertEqual(run.call_count, 1)

    def test_share_uses_only_fresh_derived_data(self):
        metadata = {"commit": "abc123", "version": "2.6.0", "buildNumber": "123.1"}

        def built(output, number):
            return metadata, output / "DerivedData"

        with patch.object(preview, "ROOT", self.root), \
                patch.dict(preview.os.environ, {}, clear=True), \
                patch("sys.argv", ["tuist-preview.py", "share"]), \
                patch.object(preview, "run", return_value='{"url":"https://tuist.dev/preview/1"}') as run, \
                patch.object(preview, "build", side_effect=built), \
                patch.object(preview, "publish_result"):
            preview.main()
            first = run.call_args.args
            preview.main()
            second = run.call_args.args
        index = first.index("--derived-data-path") + 1
        self.assertNotEqual(first[index], second[index])
        self.assertEqual(first[:3], ("tuist", "share", "Mulimi"))
        self.assertEqual(first[first.index("--configuration") + 1], "Debug")

    def test_ci_upload_does_not_require_user_project_lookup(self):
        metadata = {"commit": "abc123", "version": "2.6.0", "buildNumber": "123.1"}
        env = {"GITHUB_ACTIONS": "true", "GITHUB_RUN_NUMBER": "123", "GITHUB_RUN_ATTEMPT": "1"}
        with patch.object(preview, "ROOT", self.root), \
                patch.dict(preview.os.environ, env, clear=True), \
                patch("sys.argv", ["tuist-preview.py", "share"]), \
                patch.object(preview, "run", return_value='{"url":"https://tuist.dev/preview/1"}') as run, \
                patch.object(preview, "build", return_value=(metadata, self.root / "DerivedData")), \
                patch.object(preview, "publish_result"):
            preview.main()
        self.assertEqual(run.call_count, 1)
        self.assertEqual(run.call_args.args[:3], ("tuist", "share", "Mulimi"))


if __name__ == "__main__":
    unittest.main()
