# MemberOrderingRule

**Source**: `Sources/SwiftMarshal/Core/Configuration/MemberOrderingRule.swift`

Defines rules for matching and ordering type members.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `enum MemberOrderingRule` |
| **Protocols** | `Equatable`, `Sendable` |

## Cases

| Case | Associated Values | Description |
|------|-------------------|-------------|
| `simple` | `MemberKind` | Match by kind only |
| `property` | `annotated: Bool?`, `visibility: Visibility?` | Match properties with optional filters |
| `method` | `kind: MethodKind?`, `visibility: Visibility?`, `annotated: Bool?` | Match methods with optional filters |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `matches(_:)` | `MemberDeclaration` | `Bool` | Check if rule matches member |

## Private Methods

| Method | Description |
|--------|-------------|
| `matchesProperty(_:annotated:visibility:)` | Property matching logic |
| `matchesMethod(_:kind:visibility:annotated:)` | Method matching logic |
| `matchesMethodKind(_:expected:)` | Method kind comparison |

## Matching Logic

### Simple Rule

Matches if `member.kind == rule.kind`.

### Property Rule

1. Member must be `.instanceProperty` or `.typeProperty`
2. If `annotated` specified, `member.isAnnotated` must match
3. If `visibility` specified, `member.visibility` must match

### Method Rule

1. Member must be `.instanceMethod` or `.typeMethod`
2. If `kind` is `.static`, member must be `.typeMethod`
3. If `kind` is `.instance`, member must be `.instanceMethod`
4. If `annotated` specified, `member.isAnnotated` must match
5. If `visibility` specified, `member.visibility` must match

## Usage in ReorderEngine

Rules are evaluated in order. First matching rule determines member's sort position.

## Related

- [ReorderEngine](../Reordering/ReorderEngine.md) - Uses rules for sorting
- [MemberKind](../Models/MemberKind.md) - Kind enum
- [Visibility](../Models/Visibility.md) - Visibility enum
- [MethodKind](MethodKind.md) - Method classification
