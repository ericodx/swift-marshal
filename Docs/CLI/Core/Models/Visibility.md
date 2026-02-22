# Visibility

**Source**: `Sources/SwiftMarshal/Core/Models/Visibility.swift`

Swift access level modifiers.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `enum Visibility` |
| **Protocols** | `String` (RawRepresentable), `Sendable`, `CaseIterable` |

## Cases

| Case | Raw Value | Description |
|------|-----------|-------------|
| `open` | `"open"` | Accessible and overridable everywhere |
| `public` | `"public"` | Accessible everywhere |
| `internal` | `"internal"` | Accessible within module |
| `fileprivate` | `"fileprivate"` | Accessible within file |
| `private` | `"private"` | Accessible within enclosing declaration |

## Default

When no visibility modifier is present, Swift defaults to `internal`.

## Usage

Used in:
- `MemberDeclaration` to track member visibility
- `MemberOrderingRule` to filter members by access level
- Configuration YAML for visibility-based rules

## Related

- [MemberDeclaration](MemberDeclaration.md) - Has visibility property
- [MemberOrderingRule](../Configuration/MemberOrderingRule.md) - Uses for filtering
