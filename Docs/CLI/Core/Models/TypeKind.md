# TypeKind

**Source**: `Sources/SwiftMarshal/Core/Models/TypeKind.swift`

Classification of Swift types.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `enum TypeKind` |
| **Protocols** | `String` (RawRepresentable), `Sendable` |

## Cases

| Case | Description |
|------|-------------|
| `class` | Reference type with inheritance |
| `struct` | Value type |
| `enum` | Sum type with cases |
| `actor` | Reference type with isolation |
| `protocol` | Abstract interface |

## Usage

Identifies which Swift declaration type is being analyzed, enabling type-specific handling in visitors and rewriters.

## Related

- [TypeDeclaration](TypeDeclaration.md) - Uses this enum
- [SyntaxTypeDeclaration](SyntaxTypeDeclaration.md) - Uses this enum
