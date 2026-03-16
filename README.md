# Swift Marshal

[![Swift Package Index](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fericodx%2Fswift-marshal%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ericodx/swift-marshal)
[![Swift Package Index](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fericodx%2Fswift-marshal%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ericodx/swift-marshal)
[![CI](https://img.shields.io/github/actions/workflow/status/ericodx/swift-marshal/main-analysis.yml?branch=main&style=flat-square&logo=github&logoColor=white&label=CI&color=4CAF50)](https://github.com/ericodx/swift-marshal/actions)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=deploy-on-friday-swift-marshal&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=deploy-on-friday-swift-marshal)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=deploy-on-friday-swift-marshal&metric=coverage)](https://sonarcloud.io/summary/new_code?id=deploy-on-friday-swift-marshal)

**Reorder Swift type members without altering logic or formatting.**

`swift-marshal` is an AST-based CLI that enforces a consistent member ordering within Swift type declarations. It reports violations with `check` and applies fixes with `fix` — both driven by SwiftSyntax and a declarative configuration file.

## Install

```bash
brew tap ericodx/homebrew-tools
brew install swift-marshal
```

Other installation methods — pre-built binary, build from source, pre-commit hook, Xcode plugin — are covered in the [Installation Guide](Docs/INSTALLATION.md).

## Quick start

```bash
# Generate a config file (auto-detects your source directories)
swift-marshal init

# Check for violations
swift-marshal check

# Apply fixes
swift-marshal fix
```

Example output:

```
Sources/App/Models/User.swift:
  struct User (line 3)
    [needs reordering]
    original:
      - instance_method fullName
      - instance_property firstName
      - initializer init
    reordered:
      - initializer init
      - instance_property firstName
      - instance_method fullName

✗ 1 type in 1 file needs reordering
  Run 'swift-marshal fix' to apply changes
```

## Configuration

Drop a `.swift-marshal.yaml` in the project root to control member order, paths, and extension handling:

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

Full reference in the [Usage & Configuration Guide](Docs/USAGE.md).

## Documentation

| Document | Description |
|---|---|
| [Installation](Docs/INSTALLATION.md) | Homebrew, binary, source, pre-commit hook, Xcode plugin |
| [Usage & Configuration](Docs/USAGE.md) | CLI options, YAML config, output formats, CI integration |
| [Architecture](Docs/Architecture/README.md) | Module map, pipeline design, configuration model, AST rewriting |
| [Codebase Reference](Docs/CodeBase/README.md) | Every type, protocol, and stage documented |
