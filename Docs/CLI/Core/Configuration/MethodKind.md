# MethodKind

**Source**: `Sources/SwiftMarshal/Core/Configuration/MethodKind.swift`

Classifies methods as static or instance.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `enum MethodKind` |
| **Protocols** | `String` (RawRepresentable), `Sendable` |

## Cases

| Case | Raw Value | Description |
|------|-----------|-------------|
| `static` | `"static"` | Type-level methods (static/class) |
| `instance` | `"instance"` | Instance methods |

## Usage

Used in `MemberOrderingRule.method` to filter methods by their kind.

## Related

- [MemberOrderingRule](MemberOrderingRule.md) - Uses this enum
- [MemberKind](../Models/MemberKind.md) - Contains `typeMethod` and `instanceMethod`
