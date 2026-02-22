# RawConfiguration

**Source**: `Sources/SwiftMarshal/Core/Configuration/RawConfiguration.swift`

Unvalidated configuration parsed directly from YAML.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct RawConfiguration` |
| **Protocols** | `Equatable`, `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `version` | `Int` | Configuration format version |
| `memberRules` | `[RawMemberRule]` | Unvalidated member rules |
| `extensionsStrategy` | `String?` | Raw strategy string |
| `respectBoundaries` | `Bool?` | Raw boundaries setting |

## Purpose

Serves as intermediate representation between YAML parsing and validated configuration. Contains raw strings that haven't been validated against known enums.

## Design Decisions

- **Optional strings**: Allows partial/invalid YAML to be represented
- **No validation**: Validation happens in `ConfigurationMapper`
- **Immutable**: All properties are `let`

## Related

- [ConfigurationLoader](ConfigurationLoader.md) - Produces this type
- [ConfigurationMapper](ConfigurationMapper.md) - Consumes this type
- [RawMemberRule](RawMemberRule.md) - Rule type used here
