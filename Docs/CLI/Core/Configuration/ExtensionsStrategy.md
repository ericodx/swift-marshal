# ExtensionsStrategy

**Source**: `Sources/SwiftMarshal/Core/Configuration/ExtensionsStrategy.swift`

Defines how extension blocks are handled during analysis.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `enum ExtensionsStrategy` |
| **Protocols** | `String` (RawRepresentable), `Equatable`, `Sendable` |

## Cases

| Case | Raw Value | Description |
|------|-----------|-------------|
| `separate` | `"separate"` | Treat each extension as independent unit |
| `merge` | `"merge"` | Merge extension members with main type |

## Current Implementation

Only `.separate` is currently implemented. Extensions are always treated as boundaries that members cannot cross.

## Related

- [Configuration](Configuration.md) - Uses this enum
- [ConfigurationMapper](ConfigurationMapper.md) - Maps string to enum
