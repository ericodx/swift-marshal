# Swift Marshal

[![Swift Package Index](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fericodx%2Fswift-marshal%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ericodx/swift-marshal)
[![Swift Package Index](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fericodx%2Fswift-marshal%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ericodx/swift-marshal)
[![CI](https://img.shields.io/github/actions/workflow/status/ericodx/swift-marshal/main-analysis.yml?branch=main&style=flat-square&logo=github&logoColor=white&label=CI&color=4CAF50)](https://github.com/ericodx/swift-marshal/actions)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=deploy-on-friday-swift-marshal&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=deploy-on-friday-swift-marshal)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=deploy-on-friday-swift-marshal&metric=coverage)](https://sonarcloud.io/summary/new_code?id=deploy-on-friday-swift-marshal)

**Reorder Swift type members without altering logic or formatting.**

Swift Marshal is an AST-based CLI that enforces a consistent member ordering within Swift type declarations. It reports violations with `check` and applies fixes with `fix` — both driven by SwiftSyntax and a declarative configuration file.

---

## Features

- **AST-based rewriting** — moves members at the syntax tree level; logic, formatting, and comments are preserved
- **Declarative configuration** — define your preferred order once in `.swift-marshal.yaml`
- **Two modes** — `check` for CI gates, `fix` for local and automated rewrites
- **Xcode integration** — build-tool plugin surfaces violations as editor warnings on every build
- **Command plugin** — apply fixes directly from Xcode's Product menu or `swift package marshal`
- **Swift 6** — built with strict concurrency enabled; safe to use in any Swift 6 project

---

## Quick Start

```bash
# 1. Generate a config file (auto-detects SPM or Xcode project layout)
swift-marshal init

# 2. Check for violations
swift-marshal check

# 3. Apply fixes
swift-marshal fix
```

```
✗ 1 type in 1 file needs reordering
  Run 'swift-marshal fix' to apply changes
```

---

## Installation

```bash
brew tap ericodx/homebrew-tools
brew install swift-marshal
```

Full installation options — Homebrew, pre-built binary, build from source, SPM run, pre-commit hook, and Xcode plugin — are covered in the [Installation Guide](Docs/INSTALLATION.md).

---

## Configuration

`swift-marshal init` writes a starter `.swift-marshal.yaml` in the current directory:

```yaml
version: 1

ordering:
  members:
    - typealias
    - associatedtype
    - initializer
    - type_property
    - instance_property
    - subtype
    - type_method
    - instance_method
    - subscript
    - deinitializer

extensions:
  strategy: separate
  respect_boundaries: true

paths:
  - Sources/
```

Rules can be simple (match by kind) or complex (match by kind + visibility + annotation). See the [Usage Guide](Docs/USAGE.md) for the full configuration reference.

---

## CLI Reference

```
swift-marshal check [files…] [--path <dir>] [--config <file>] [--xcode] [--warn-only] [-q]
swift-marshal fix   [files…] [--path <dir>] [--config <file>] [--dry-run] [-q]
swift-marshal init  [--force]
```

**Exit codes:** `0` success · `1` violations found (`check`) or changes needed (`fix --dry-run`) · `2` error

---

## Xcode Integration (Build Phase)

Add the package to `Package.swift` and attach the build-tool plugin to any target:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/ericodx/swift-marshal.git", from: "1.0.0")
],
targets: [
    .target(
        name: "MyTarget",
        plugins: [.plugin(name: "SwiftMarshalPlugin", package: "swift-marshal")]
    )
]
```

The plugin runs `check --xcode` on every build and surfaces violations as Xcode build warnings. To apply fixes, run `swift package marshal` or use **Product → SwiftMarshal** in Xcode.

---

## Documentation

| Document | Contents |
|---|---|
| [Installation Guide](Docs/INSTALLATION.md) | Homebrew, binary, source, SPM run, pre-commit hook, Xcode plugin |
| [Usage Guide](Docs/USAGE.md) | Commands, flags, configuration, CI/CD, output formats, exit codes |
| [Architecture](Docs/Architecture/README.md) | Module map, pipeline design, configuration model, AST rewriting |
| [Codebase Reference](Docs/CodeBase/README.md) | Every type, function, and protocol in the production codebase |
