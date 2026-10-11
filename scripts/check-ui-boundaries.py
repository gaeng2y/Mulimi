#!/usr/bin/env python3
"""Check Swift imports and literal Tuist target declarations for the UI layers."""

import json
from pathlib import Path
import re
import sys

FOUNDATION = "DesignSystemFoundation"
UI_SYSTEM = "MulimiUISystem"
UI_MODULES = {FOUNDATION, UI_SYSTEM, "DesignSystem"}
TOKEN = re.compile(r'//[^\n]*|/\*.*?\*/|"(?:\\.|[^"\\])*"|[A-Za-z_]\w*|[^\s]', re.S)
IMPORT_KINDS = {"typealias", "struct", "class", "enum", "protocol", "let", "var", "func"}


def tokens(source):
    return [(match.group(), source.count("\n", 0, match.start()) + 1)
            for match in TOKEN.finditer(source) if not match.group().startswith(("//", "/*"))]


def calls(items, kind):
    """Read balanced .target/.project calls, including nested dependency calls."""
    for index in range(len(items) - 2):
        if [item[0] for item in items[index:index + 3]] != [".", kind, "("]:
            continue
        depth = 1
        end = index + 3
        while end < len(items) and depth:
            token = items[end][0]
            depth += (token == "(") - (token == ")")
            end += 1
        if depth:
            raise ValueError(f"Unclosed .{kind} call on line {items[index][1]}")
        yield items[index + 3:end - 1]


def fields(items):
    result = {}
    depth = 0
    for index in range(len(items) - 2):
        value = items[index][0]
        if depth == 0 and items[index + 1][0] == ":":
            result[value] = items[index + 2][0]
        depth += (value in ("(", "[", "{")) - (value in (")", "]", "}"))
    return result


def target_declarations(source):
    for body in calls(tokens(source), "target"):
        args = fields(body)
        if "product" not in args:
            continue
        name = json.loads(args["name"])
        dependencies = []
        for kind, label in (("target", "name"), ("project", "target"), ("external", "name")):
            for dependency in calls(body, kind):
                dependencies.append(json.loads(fields(dependency)[label]))
        yield name, dependencies, body[0][1]


def check(root):
    errors = []
    for path in sorted((root / "Project").rglob("*.swift")):
        if any(part in {"Derived", ".build"} or part.endswith(".xcodeproj") for part in path.parts):
            continue
        relative = path.relative_to(root)
        source = path.read_text()

        def report(line, message):
            errors.append(f"{relative}:{line}: error: {message}")

        if path.name == "Project.swift":
            for name, dependencies, line in target_declarations(source):
                if name == "DesignSystem":
                    report(line, "The legacy DesignSystem target must not be restored.")
                for dependency in dependencies:
                    if dependency == "DesignSystem":
                        report(line, f"{name} must use MulimiUISystem instead of DesignSystem.")
                    if name == FOUNDATION or (name == UI_SYSTEM and dependency != FOUNDATION):
                        report(line, f"{name} must not depend on {dependency}.")
                    if dependency == FOUNDATION and name not in {UI_SYSTEM, FOUNDATION + "Tests"}:
                        report(line, f"{name} must consume MulimiUISystem, not Foundation directly.")
                    if name.endswith("Domain") and dependency in UI_MODULES:
                        report(line, f"{name} must not depend on UI modules.")
            continue

        module = relative.parts[2] if relative.parts[:2] == ("Project", "Shared") else None
        items = tokens(source)
        for index, (token, line) in enumerate(items[:-1]):
            if token != "import":
                continue
            next_index = index + 1
            if items[next_index][0] in IMPORT_KINDS:
                next_index += 1
            imported = items[next_index][0]
            if imported == "DesignSystem":
                report(line, "Import MulimiUISystem instead of the legacy DesignSystem.")
            if imported == FOUNDATION and module not in {FOUNDATION, UI_SYSTEM}:
                report(line, "Consumers must import MulimiUISystem, not Foundation directly.")
            if "Domain" in relative.parts and imported in UI_MODULES:
                report(line, "Domain must not import UI modules.")
            if module in {FOUNDATION, UI_SYSTEM} and "Tests" not in relative.parts:
                allowed = {"SwiftUI", "UIKit", "Foundation", "CoreGraphics"}
                if module == UI_SYSTEM:
                    allowed.add(FOUNDATION)
                if imported not in allowed:
                    report(line, f"{module} must not import {imported}.")
    return errors


if __name__ == "__main__":
    violations = check(Path(__file__).resolve().parent.parent)
    if violations:
        print("\n".join(violations), file=sys.stderr)
        sys.exit(1)
    print("UI module boundary checks passed.")
