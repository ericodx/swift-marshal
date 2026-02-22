# MemberKind

**Source**: `Sources/SwiftMarshal/Core/Models/MemberKind.swift`

Classification of type members.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `enum MemberKind` |
| **Protocols** | `String` (RawRepresentable), `Sendable`, `CaseIterable` |

## Cases

| Case | Raw Value | Description |
|------|-----------|-------------|
| `typealias` | `"typealias"` | Type alias declaration |
| `associatedtype` | `"associatedtype"` | Protocol associated type |
| `initializer` | `"initializer"` | init declaration |
| `typeProperty` | `"type_property"` | Static/class property |
| `instanceProperty` | `"instance_property"` | Instance property |
| `subtype` | `"subtype"` | Nested type declaration |
| `typeMethod` | `"type_method"` | Static/class method |
| `instanceMethod` | `"instance_method"` | Instance method |
| `subscript` | `"subscript"` | Subscript declaration |
| `deinitializer` | `"deinitializer"` | deinit declaration |

## Raw Values

Raw values match YAML configuration keys, enabling direct mapping from configuration files.

## CaseIterable

Used to generate default configuration containing all member kinds in declaration order.

## Related

- [MemberDeclaration](MemberDeclaration.md) - Uses this enum
- [MemberOrderingRule](../Configuration/MemberOrderingRule.md) - References in rules
