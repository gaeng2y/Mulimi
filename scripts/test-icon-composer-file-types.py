"""Run with python3 scripts/test-icon-composer-file-types.py on macOS."""

from pathlib import Path
import plistlib
import runpy
import tempfile


fix = runpy.run_path(str(Path(__file__).with_name("fix-icon-composer-file-types.py")))["fix_icon_file_types"]
with tempfile.TemporaryDirectory() as directory:
    project_path = Path(directory) / "project.pbxproj"
    project_path.write_text('''// !$*UTF8*$!
    {
        objects = {
            missing = {isa = PBXFileReference; path = "Mulimi-Drop.icon"; };
            wrong = {isa = PBXFileReference; path = "Other.icon"; explicitFileType = folder; };
            correct = {isa = PBXFileReference; path = "Correct.icon"; lastKnownFileType = "folder.iconcomposer.icon"; };
            catalog = {isa = PBXFileReference; path = "Assets.xcassets"; lastKnownFileType = "folder.assetcatalog"; };
            resources = {isa = PBXResourcesBuildPhase; files = (missing, wrong, correct, catalog); };
        };
        rootObject = resources;
    }
    ''')
    fix(project_path)
    result = plistlib.loads(project_path.read_bytes())
    objects = result["objects"]
    assert objects["missing"]["explicitFileType"] == "folder.iconcomposer.icon"
    assert objects["wrong"]["explicitFileType"] == "folder.iconcomposer.icon"
    assert objects["correct"] == {
        "isa": "PBXFileReference", "path": "Correct.icon", "lastKnownFileType": "folder.iconcomposer.icon"
    }
    assert objects["catalog"] == {
        "isa": "PBXFileReference", "path": "Assets.xcassets", "lastKnownFileType": "folder.assetcatalog"
    }
    assert objects["resources"]["files"] == ["missing", "wrong", "correct", "catalog"]
    assert result["rootObject"] == "resources"
    first = project_path.read_bytes()
    fix(project_path)
    assert project_path.read_bytes() == first

    project_path.write_bytes(plistlib.dumps({"objects": {"catalog": objects["catalog"]}}))
    first = project_path.read_bytes()
    try:
        fix(project_path)
    except SystemExit as error:
        assert "No Icon Composer resource" in str(error)
    else:
        raise AssertionError("A missing icon resource must fail before archiving")
    assert project_path.read_bytes() == first
print("Icon Composer file type regression checks passed")
