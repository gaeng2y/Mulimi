"""Declare Icon Composer resources explicitly in a generated Xcode project."""

import json
from pathlib import Path
import plistlib
import subprocess
import sys


def fix_icon_file_types(project_path: Path) -> None:
    project = json.loads(subprocess.check_output([
        "plutil", "-convert", "json", "-o", "-", str(project_path)
    ]))
    icons = [
        item for item in project["objects"].values()
        if item.get("isa") == "PBXFileReference" and item.get("path", "").endswith(".icon")
    ]
    if not icons:
        raise SystemExit(f"No Icon Composer resource found in {project_path}")

    changed = False
    for icon in icons:
        if icon.get("explicitFileType", icon.get("lastKnownFileType")) != "folder.iconcomposer.icon":
            icon["explicitFileType"] = "folder.iconcomposer.icon"
            changed = True
    if changed:
        # Xcode reads XML property lists; preserve every object without patching OpenStep text.
        project_path.write_bytes(plistlib.dumps(project, sort_keys=False))
    print(f"Verified {len(icons)} Icon Composer resource(s) in {project_path}")


if __name__ == "__main__":
    fix_icon_file_types(Path(sys.argv[1]))
