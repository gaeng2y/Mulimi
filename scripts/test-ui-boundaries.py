#!/usr/bin/env python3
"""Regression fixtures for imports and manifests; does not edit the workspace."""

import importlib.util
from pathlib import Path
import tempfile
import sys
import unittest

sys.dont_write_bytecode = True

spec = importlib.util.spec_from_file_location("ui_boundaries", Path(__file__).with_name("check-ui-boundaries.py"))
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)


class UIBoundaryTests(unittest.TestCase):
    def inspect(self, path, content):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            file = root / path
            file.parent.mkdir(parents=True)
            file.write_text(content)
            return checker.check(root)

    def manifest(self, target, dependency):
        return f'''.target(
            name: "{target}",
            product: .framework,
            sources: ["Sources/**"],
            dependencies: [
                .project(
                    target: "{dependency}",
                    path: .relativeToRoot("Project/Shared/{dependency}")
                )
            ]
        )'''

    def test_valid_ui_layers(self):
        self.assertEqual(self.inspect("Project/Shared/MulimiUISystem/Project.swift",
                                     self.manifest("MulimiUISystem", "DesignSystemFoundation")), [])
        self.assertEqual(self.inspect("Project/Shared/MulimiUISystem/Sources/Theme.swift",
                                     "internal import DesignSystemFoundation\nimport SwiftUI"), [])
        self.assertEqual(self.inspect("Project/Shared/DesignSystemFoundation/Sources/Tokens.swift",
                                     "import SwiftUI"), [])

    def test_consumer_direct_imports(self):
        for path in ("App/Sources/App.swift", "Features/Hydration/Presentation/Sources/View.swift"):
            for prefix in ("import", "@_exported import", "internal import", "import struct"):
                with self.subTest(path=path, prefix=prefix):
                    self.assertTrue(self.inspect("Project/" + path, prefix + " DesignSystemFoundation"))

    def test_reverse_imports(self):
        for module, imported in (("DesignSystemFoundation", "MulimiUISystem"),
                                 ("DesignSystemFoundation", "AccountDomain"),
                                 ("MulimiUISystem", "Localization"),
                                 ("MulimiUISystem", "MulimiNavigation"),
                                 ("MulimiUISystem", "HydrationData")):
            with self.subTest(module=module, imported=imported):
                self.assertTrue(self.inspect(f"Project/Shared/{module}/Sources/UI.swift", "import " + imported))

    def test_domain_imports(self):
        for module in checker.UI_MODULES:
            self.assertTrue(self.inspect("Project/Features/Hydration/Domain/Sources/Entity.swift", "import " + module))

    def test_manifest_boundaries(self):
        for target, dependency in (("Mulimi", "DesignSystemFoundation"),
                                   ("HydrationPresentation", "DesignSystemFoundation"),
                                   ("DesignSystemFoundation", "MulimiUISystem"),
                                   ("MulimiUISystem", "Localization"),
                                   ("MulimiUISystem", "HydrationDomain"),
                                   ("HydrationDomain", "MulimiUISystem"),
                                   ("HydrationDomain", "DesignSystemFoundation"),
                                   ("ChallengePresentation", "DesignSystem")):
            with self.subTest(target=target, dependency=dependency):
                self.assertTrue(self.inspect("Project/Features/Hydration/Project.swift",
                                             self.manifest(target, dependency)))

    def test_local_target_dependency(self):
        source = '.target(name: "HydrationDomain", product: .framework, dependencies: [.target(name: "MulimiUISystem")])'
        self.assertTrue(self.inspect("Project/Features/Hydration/Project.swift", source))

    def test_comments_and_strings_are_not_imports(self):
        source = '// import DesignSystemFoundation\n/* import DesignSystem */\nlet text = "import MulimiUISystem"'
        self.assertEqual(self.inspect("Project/Features/Hydration/Domain/Sources/Entity.swift", source), [])


if __name__ == "__main__":
    unittest.main()
