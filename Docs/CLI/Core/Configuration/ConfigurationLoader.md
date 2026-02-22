# ConfigurationLoader

**Source**: `Sources/SwiftMarshal/Core/Configuration/ConfigurationLoader.swift`

Parses YAML content into raw, unvalidated configuration structs.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ConfigurationLoader` |

## Dependencies

| Dependency | Usage |
|------------|-------|
| `Yams` | YAML parsing library |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `parse(_:)` | `content: String` | `RawConfiguration` | Parse YAML string |

## Private Methods

| Method | Description |
|--------|-------------|
| `parseOrderingRules(from:)` | Extract member rules from `ordering.members` |
| `parseRule(from:)` | Parse single rule (simple or complex) |
| `parseExtensions(from:)` | Extract extensions settings |

## YAML Structure

```yaml
version: 1

ordering:
  members:
    - typealias              # Simple rule
    - property:              # Complex property rule
        annotated: true
        visibility: private
    - method:                # Complex method rule
        kind: static
        visibility: public

extensions:
  strategy: separate
  respect_boundaries: true
```

## Rule Parsing

| YAML Type | Parsed As |
|-----------|-----------|
| String | `RawMemberRule.simple(String)` |
| `property:` dict | `RawMemberRule.property(...)` |
| `method:` dict | `RawMemberRule.method(...)` |

## Design Decisions

- **Raw output**: Produces unvalidated strings, not enums
- **Tolerant parsing**: Unknown keys are ignored
- **Optional fields**: Missing fields become `nil`

## Related

- [RawConfiguration](RawConfiguration.md) - Output type
- [RawMemberRule](RawMemberRule.md) - Rule output type
