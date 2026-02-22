# Configuration

**Source**: `Sources/SwiftMarshal/Core/Configuration/Configuration.swift`

Final validated configuration model used throughout the application.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct Configuration` |
| **Protocols** | `Equatable`, `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `version` | `Int` | Configuration format version |
| `memberOrderingRules` | `[MemberOrderingRule]` | Ordered list of member rules |
| `extensionsStrategy` | `ExtensionsStrategy` | How to handle extensions |
| `respectBoundaries` | `Bool` | Whether to respect extension boundaries |

## Static Properties

| Property | Description |
|----------|-------------|
| `default` | Default configuration with all member kinds in declaration order |

## Default Configuration

The default configuration:
- Version: 1
- Rules: All `MemberKind` cases as simple rules
- Extensions strategy: `.separate`
- Respect boundaries: `true`

## Usage

Configuration is created by `ConfigurationMapper` from `RawConfiguration`, or obtained via the `default` static property when no configuration file exists.

## Related

- [ConfigurationMapper](ConfigurationMapper.md) - Creates Configuration instances
- [MemberOrderingRule](MemberOrderingRule.md) - Rule type used in configuration
- [ExtensionsStrategy](ExtensionsStrategy.md) - Strategy enum
