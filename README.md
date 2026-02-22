# Swift Marshal

![Platform](https://img.shields.io/badge/platform-macOS%2015%2B-orange?style=flat-square&logo=apple&logoColor=white)
![Swift](https://img.shields.io/badge/swift-6.0%2B-orange?style=flat-square&logo=swift&logoColor=white)
[![CI](https://img.shields.io/github/actions/workflow/status/ericodx/swift-marshal/main-analysis.yml?branch=main&style=flat-square&logo=github&logoColor=white&label=CI&color=4CAF50)](https://github.com/ericodx/swift-marshal/actions)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=deploy-on-friday-swift-marshal&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=deploy-on-friday-swift-marshal)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=deploy-on-friday-swift-marshal&metric=coverage)](https://sonarcloud.io/summary/new_code?id=deploy-on-friday-swift-marshal)

**Reorder Swift type members without rewriting code.**

Swift Marshal is an AST-based CLI tool built on SwiftSyntax.

It focuses exclusively on **members organization** of Swift types — not formatting, not syntax rewriting, and not templates.

---

## What Swift Marshal Does

- Reorders and groups members **within the same declaration scope**
- Reorders members inside individual `extension` blocks only
- Treats `extension` blocks as hard structural boundaries
- Never moves members across extensions or files
- Preserves comments, trivia, and original formatting
- Produces deterministic output

---

## Installation

The recommended way to install Swift Marshal is via Homebrew:

```bash
brew tap ericodx/homebrew-tools
brew install swift-marshal
```

### Other Installation Methods

**[View Complete Installation Guide](Docs/INSTALLATION.md)**

- Manual build from source
- Direct download of pre-compiled binaries
- Troubleshooting and updates

---

## Usage

### Check files for ordering issues

```bash
# Single file
swift-marshal check Sources/App/MyFile.swift

# All .swift files in a directory (recursive)
swift-marshal check --path Sources

# Quiet mode (CI-friendly, only shows files needing changes)
swift-marshal check --quiet --path Sources
```

Exit codes:
- `0` - All files are correctly ordered
- `1` - One or more files need reordering

### Fix files

```bash
# Single file
swift-marshal fix Sources/App/MyFile.swift

# All .swift files in a directory (recursive)
swift-marshal fix --path Sources

# Preview changes without modifying files
swift-marshal fix --dry-run --path Sources

# Quiet mode (only show summary)
swift-marshal fix --quiet --path Sources
```

---

## Xcode Integration

### Build Tool Plugin (Recommended)

The easiest way to integrate Swift Marshal into your Xcode workflow is via the **Build Tool Plugin**. It runs automatically during builds and shows warnings inline in the editor.

**Swift Package Manager:**

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/ericodx/swift-marshal", from: "1.2.0"),
]

targets: [
    .target(
        name: "MyApp",
        plugins: [
            .plugin(name: "SwiftMarshalPlugin", package: "swift-marshal")
        ]
    ),
]
```

**Xcode Projects:**

1. Add `swift-marshal` as a package dependency
2. Select your target → **Build Phases**
3. Add **SwiftMarshalPlugin** to "Run Build Tool Plug-ins"

> **Note:** The plugin only supports `check` mode due to SPM sandbox restrictions. Use the CLI directly for `fix` operations.

### Build Phase (Alternative)

For more control or to use `fix`, add a Run Script Build Phase:

```bash
if which swift-marshal > /dev/null; then
    swift-marshal check --xcode --path "${SRCROOT}/Sources"
fi
```

See [Xcode Integration Guide](Docs/Examples/xcode-integration.md) for complete setup options.

---

## CI Integration

### GitHub Actions

```yaml
- name: Check structure
  run: swift-marshal check Sources/**/*.swift
```

### pre-commit

```yaml
hooks:
  - id: swift-marshal
    entry: swift-marshal check --quiet
    files: \.swift$
```

See [CI Integration](Docs/Examples/ci-integration.md) for complete guides.

---

## Configuration

Swift Marshal uses **`.swift-marshal.yaml`** for configuration.

```bash
# Initialize configuration file
swift-marshal init
```

See [Configuration Reference](Docs/CONFIGURATION.md) for complete documentation.

### Example Configurations

| Example | Use Case |
|---------|----------|
| [minimal.yaml](Docs/Examples/minimal.yaml) | Basic ordering |
| [swiftui.yaml](Docs/Examples/swiftui.yaml) | SwiftUI with property wrappers |
| [uikit.yaml](Docs/Examples/uikit.yaml) | UIKit with lifecycle methods |
| [visibility-focused.yaml](Docs/Examples/visibility-focused.yaml) | Libraries and frameworks |

---

## Documentation

| Document | Description |
|----------|-------------|
| [Architecture](Docs/Architecture/README.md) | System design and patterns |
| [CI/CD](Docs/CI/README.md) | GitHub Actions workflows and automation |
| [CLI Reference](Docs/CLI/README.md) | Commands and implementation |
| [Configuration](Docs/CONFIGURATION.md) | YAML schema and options |
| [Examples](Docs/Examples/README.md) | Configuration examples |

### Integration Guides

| Guide | Description |
|-------|-------------|
| [Xcode Integration](Docs/Examples/xcode-integration.md) | Build phases, hooks, behaviors |
| [CI Integration](Docs/Examples/ci-integration.md) | GitHub Actions, GitLab CI, etc. |
