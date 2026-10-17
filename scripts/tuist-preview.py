#!/usr/bin/env python3
"""Build and share a verified Mulimi iOS Simulator preview."""

import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import plistlib
import re
import shlex
import subprocess
import tempfile
from urllib.parse import urlparse


ROOT = Path(__file__).resolve().parents[1]
FULL_HANDLE = "gaeng2y/mulimi"


def run(*args, capture=False):
    print(f"+ {shlex.join(str(arg) for arg in args)}", flush=True)
    result = subprocess.run(
        [str(arg) for arg in args], cwd=ROOT, check=True,
        text=True, stdout=subprocess.PIPE if capture else None,
    )
    return result.stdout.strip() if capture else None


def build_number(env):
    number = env.get("PREVIEW_BUILD_NUMBER")
    if not number:
        if env.get("GITHUB_ACTIONS") == "true":
            # Attempts change on reruns of the same workflow run.
            number = f"{env['GITHUB_RUN_NUMBER']}.{env['GITHUB_RUN_ATTEMPT']}"
        else:
            number = datetime.now(timezone.utc).strftime("%Y%m%d%H%M%S")
    if not re.fullmatch(r"[0-9]+(?:\.[0-9]+){0,2}", number):
        raise ValueError("PREVIEW_BUILD_NUMBER must contain one to three numeric components.")
    return number


def prepare_settings():
    path = ROOT / "XCConfig/Secrets.xcconfig"
    if not path.exists():
        template = (ROOT / "XCConfig/Secrets.xcconfig.template").read_text()
        team = os.environ.get("TEAM_ID", "8UV3Y69NB7")
        if not re.fullmatch(r"[A-Z0-9]{10}", team):
            raise ValueError("TEAM_ID must be a 10-character Apple Developer team identifier.")
        path.write_text(template.replace("YOUR_TEAM_ID", team))
        print("Created XCConfig/Secrets.xcconfig for the simulator build.")


def verify_app(app, number):
    bundles = [
        (app, "gaeng2y.DrinkWater", "iPhoneSimulator"),
        (app / "PlugIns/WidgetExtension.appex", "gaeng2y.DrinkWater.WidgetExtension", "iPhoneSimulator"),
        (app / "Watch/MulimiWatch.app", "gaeng2y.DrinkWater.watchkitapp", "WatchSimulator"),
    ]
    marketing_version = None
    for bundle, identifier, platform in bundles:
        with (bundle / "Info.plist").open("rb") as stream:
            info = plistlib.load(stream)
        if info.get("CFBundleIdentifier") != identifier:
            raise ValueError(f"Unexpected bundle identifier: {bundle}")
        if info.get("CFBundleVersion") != number:
            raise ValueError(f"Stale or inconsistent build number: {bundle}")
        if platform not in info.get("CFBundleSupportedPlatforms", []):
            raise ValueError(f"Expected {platform} build: {bundle}")
        version = info.get("CFBundleShortVersionString")
        if not version or (marketing_version and version != marketing_version):
            raise ValueError(f"Inconsistent marketing version: {bundle}")
        marketing_version = version
        executable = info.get("CFBundleExecutable", "")
        if not executable or not (bundle / executable).is_file():
            raise ValueError(f"Missing bundle executable: {bundle}")

    if not (app / "Assets.car").is_file():
        raise ValueError("Compiled app assets are missing.")
    frameworks = app / "Frameworks"
    for name in ("Localization", "DesignSystemFoundation", "MulimiUISystem"):
        if not (frameworks / f"{name}.framework" / name).is_file():
            raise ValueError(f"Missing embedded framework: {name}")
    print(f"Verified app, Widget, Watch and resources: {marketing_version} ({number})")
    return marketing_version


def preview_url(data):
    url = data.get("url", "")
    parsed = urlparse(url)
    if parsed.scheme != "https" or parsed.netloc != "tuist.dev" or not parsed.path.strip("/"):
        raise ValueError("Tuist did not return a valid Preview URL.")
    return url


def publish_result(response, metadata, output, env):
    url = preview_url(response)
    result = {**metadata, "url": url}
    (output / "preview.json").write_text(json.dumps(result, indent=2) + "\n")
    summary = env.get("GITHUB_STEP_SUMMARY")
    if summary:
        with Path(summary).open("a") as stream:
            stream.write(
                "## Mulimi Preview\n\n"
                f"[시뮬레이터 Preview 실행]({url})\n\n"
                f"- 커밋: `{metadata['commit']}`\n"
                f"- 버전: `{metadata['version']} ({metadata['buildNumber']})`\n"
                "- 구성: `Mulimi / Debug / iOS Simulator`\n"
                f"- 실행: `tuist run {url}`\n"
            )
    print(f"Preview: {url}")
    print(f"Run: tuist run {shlex.quote(url)}")


def build(output, number):
    commit = run("git", "rev-parse", "HEAD", capture=True)
    dirty = bool(run("git", "status", "--porcelain", capture=True))
    prepare_settings()
    run("tuist", "version")
    run("xcodebuild", "-version")
    run("xcodebuild", "-showsdks")
    run("tuist", "install")
    run("tuist", "generate", "--no-open", "--no-binary-cache")
    project = ROOT / "Project/App/Mulimi App.xcodeproj/project.pbxproj"
    run("python3", "scripts/fix-icon-composer-file-types.py", project)
    run("python3", "scripts/test-icon-composer-file-types.py", project)
    derived_data = output / "DerivedData"
    run(
        "xcodebuild", "build", "-workspace", "Mulimi.xcworkspace", "-scheme", "Mulimi",
        # Let Xcode choose each target's SDK so the embedded Watch app uses watchsimulator.
        "-configuration", "Debug",
        "-destination", "generic/platform=iOS Simulator", "-derivedDataPath", derived_data,
        f"APP_BUILD_NUMBER={number}", "CODE_SIGNING_ALLOWED=NO", "CODE_SIGNING_REQUIRED=NO",
        # Preview sessions use the existing NoOp analytics path.
        "POSTHOG_PROJECT_TOKEN=", "POSTHOG_HOST=",
    )
    app = derived_data / "Build/Products/Debug-iphonesimulator/Mulimi.app"
    version = verify_app(app, number)
    metadata = {
        "commit": commit, "workingTreeDirty": dirty,
        "version": version, "buildNumber": number,
        "configuration": "Debug", "platform": "iOS Simulator",
        "app": str(app),
    }
    (output / "build.json").write_text(json.dumps(metadata, indent=2) + "\n")
    return metadata, derived_data


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("build", "share"))
    args = parser.parse_args()
    number = build_number(os.environ)
    if args.action == "share" and os.environ.get("GITHUB_ACTIONS") != "true":
        # project show checks a user session; CI authenticates with OIDC in the workflow.
        # The upload endpoint authorizes the CI subject when sharing the preview.
        run("tuist", "project", "show", FULL_HANDLE)
    parent = ROOT / ".build/tuist-preview"
    parent.mkdir(parents=True, exist_ok=True)
    # Each invocation gets fresh products; an older build can never be uploaded.
    output = Path(tempfile.mkdtemp(prefix="run-", dir=parent))
    print(f"Preview output: {output}", flush=True)
    metadata, derived_data = build(output, number)
    if args.action == "share":
        response = run(
            "tuist", "share", "Mulimi", "--configuration", "Debug", "--platforms", "iOS",
            "--derived-data-path", derived_data, "--json", capture=True,
        )
        publish_result(json.loads(response), metadata, output, os.environ)
    print(f"Build details: {output / 'build.json'}")


if __name__ == "__main__":
    try:
        main()
    except (subprocess.CalledProcessError, OSError, ValueError, KeyError) as error:
        raise SystemExit(f"Preview failed: {error}") from error
