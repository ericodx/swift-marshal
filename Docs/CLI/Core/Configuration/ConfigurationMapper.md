# ConfigurationMapper

**Source**: `Sources/SwiftMarshal/Core/Configuration/ConfigurationMapper.swift`

Maps raw configuration to validated domain models.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ConfigurationMapper` |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `map(_:)` | `RawConfiguration` | `Configuration` | Map raw to validated config |

## Private Methods

| Method | Description |
|--------|-------------|
| `mapMemberRules(_:)` | Map raw rules to validated rules |
| `mapMemberRule(_:)` | Map single raw rule |
| `mapExtensionsStrategy(_:)` | Map strategy string to enum |
| `defaultRules()` | Generate default rules when none valid |

## Mapping Logic

### Member Rules

| Raw | Validated |
|-----|-----------|
| `.simple(String)` | `.simple(MemberKind)` if valid |
| `.property(...)` | `.property(...)` with `Visibility?` |
| `.method(...)` | `.method(...)` with `MethodKind?`, `Visibility?` |

Invalid raw values (unknown strings) are filtered out via `compactMap`.

### Extensions Strategy

| Raw String | Validated |
|------------|-----------|
| `"separate"` | `.separate` |
| `"merge"` | `.merge` |
| `nil` or unknown | `.separate` (default) |

### Boundaries

| Raw | Validated |
|-----|-----------|
| `true` | `true` |
| `false` | `false` |
| `nil` | `true` (default) |

## Fallback Behavior

If all member rules are invalid (none map successfully), the mapper returns default rules containing all `MemberKind` cases.

## Related

- [RawConfiguration](RawConfiguration.md) - Input type
- [Configuration](Configuration.md) - Output type
- [MemberOrderingRule](MemberOrderingRule.md) - Rule domain model
