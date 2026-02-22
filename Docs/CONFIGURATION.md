# Configuration Reference

Complete reference for `.swift-marshal.yaml` configuration file.

## Overview

Swift Marshal uses a YAML configuration file to define how members within Swift types should be ordered. The configuration is explicit, declarative, and deterministic.

### Principles

| Principle | Description |
|-----------|-------------|
| **Explicit** | All rules must be explicitly defined |
| **Declarative** | Configuration describes desired state |
| **Deterministic** | Same input always produces same output |
| **No inference** | No automatic guessing or defaults |

### File Location

Swift Marshal looks for `.swift-marshal.yaml` in the current working directory.

```bash
# Initialize configuration file
swift-marshal init

# Initialize with force overwrite
swift-marshal init --force
```

## Schema

### Top-Level Structure

```yaml
version: 1

ordering:
  members:
    - # member rules...

extensions:
  strategy: separate
  respect_boundaries: true
```

| Key | Type | Required | Description |
|-----|------|----------|-------------|
| `version` | `Int` | Yes | Schema version (currently `1`) |
| `ordering` | `Object` | Yes | Ordering configuration |
| `ordering.members` | `Array` | Yes | List of member ordering rules |
| `extensions` | `Object` | No | Extension handling configuration |

## Member Ordering Rules

Members are ordered according to the sequence defined in `ordering.members`. Rules are evaluated in order - the first matching rule determines the member's position.

### Simple Rules

Simple rules match members by their kind:

```yaml
ordering:
  members:
    - typealias
    - associatedtype
    - initializer
    - subtype
    - subscript
    - deinitializer
```

### Available Member Kinds

| Kind | YAML Key | Description |
|------|----------|-------------|
| Type Alias | `typealias` | `typealias` declarations |
| Associated Type | `associatedtype` | `associatedtype` in protocols |
| Initializer | `initializer` | `init` methods |
| Type Property | `type_property` | `static` / `class` properties |
| Instance Property | `instance_property` | Instance properties |
| Subtype | `subtype` | Nested types (`struct`, `class`, `enum`) |
| Type Method | `type_method` | `static` / `class` methods |
| Instance Method | `instance_method` | Instance methods |
| Subscript | `subscript` | `subscript` declarations |
| Deinitializer | `deinitializer` | `deinit` method |

### Property Rules

Property rules allow filtering by annotation and visibility:

```yaml
ordering:
  members:
    # All annotated properties (e.g., @State, @Published)
    - property:
        annotated: true

    # Public properties only
    - property:
        visibility: public

    # Private non-annotated properties
    - property:
        annotated: false
        visibility: private
```

| Option | Type | Values | Description |
|--------|------|--------|-------------|
| `annotated` | `Bool` | `true`, `false` | Filter by presence of attributes |
| `visibility` | `String` | See visibility table | Filter by access level |

### Method Rules

Method rules allow filtering by kind, visibility, and annotation:

```yaml
ordering:
  members:
    # All static methods
    - method:
        kind: static

    # Public instance methods
    - method:
        kind: instance
        visibility: public

    # Annotated methods (e.g., @MainActor)
    - method:
        annotated: true
```

| Option | Type | Values | Description |
|--------|------|--------|-------------|
| `kind` | `String` | `static`, `instance` | Method type |
| `visibility` | `String` | See visibility table | Access level |
| `annotated` | `Bool` | `true`, `false` | Has attributes |

### Visibility Levels

| Level | YAML Key | Description |
|-------|----------|-------------|
| Open | `open` | Accessible and overridable outside module |
| Public | `public` | Accessible outside module |
| Internal | `internal` | Accessible within module (default) |
| File Private | `fileprivate` | Accessible within file |
| Private | `private` | Accessible within enclosing declaration |

## Extensions Configuration

```yaml
extensions:
  strategy: separate
  respect_boundaries: true
```

| Option | Type | Values | Description |
|--------|------|--------|-------------|
| `strategy` | `String` | `separate`, `merge` | How to handle extensions |
| `respect_boundaries` | `Bool` | `true` | Never move members across extensions |

### Strategy Values

| Strategy | Description |
|----------|-------------|
| `separate` | Each extension is processed independently |
| `merge` | Extensions are merged (not yet implemented) |

**Important**: `respect_boundaries` must always be `true`. Moving members across extension boundaries is not supported.

## Rule Evaluation

Rules are evaluated in order. The first matching rule determines the member's position:

```yaml
ordering:
  members:
    # Rule 1: Annotated properties first
    - property:
        annotated: true

    # Rule 2: Then public properties
    - property:
        visibility: public

    # Rule 3: Then all other properties
    - property:
```

For a `@Published public var name: String`:
1. Matches Rule 1 (annotated) → positioned first
2. Rules 2 and 3 are not evaluated

For a `public var count: Int`:
1. Does not match Rule 1 (not annotated)
2. Matches Rule 2 (public) → positioned second

## Default Configuration

When no configuration file is found, Swift Marshal uses this default ordering:

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
```

## Examples

See the [Examples](Examples/README.md) directory for complete configuration examples:

| Example | Use Case |
|---------|----------|
| [Minimal](Examples/minimal.yaml) | Simplest possible configuration |
| [SwiftUI](Examples/swiftui.yaml) | SwiftUI projects with property wrappers |
| [UIKit](Examples/uikit.yaml) | UIKit projects with lifecycle methods |
| [Visibility-focused](Examples/visibility-focused.yaml) | Ordering by access level |

## Integration Guides

| Guide | Description |
|-------|-------------|
| [Xcode Integration](Examples/xcode-integration.md) | Run as build phase or script |
| [CI Integration](Examples/ci-integration.md) | GitHub Actions, GitLab CI, etc. |

## Validation

Swift Marshal validates the configuration on load. Invalid configuration causes execution failure with a descriptive error message.

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| File not found | No `.swift-marshal.yaml` | Run `swift-marshal init` |
| Invalid YAML | Syntax error in YAML | Check YAML syntax |
| Unknown member kind | Typo in member kind | Use valid member kind |
| Invalid visibility | Typo in visibility | Use valid visibility level |
