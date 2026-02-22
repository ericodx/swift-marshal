# TypeDeclaration

**Source**: `Sources/SwiftMarshal/Core/Models/TypeDeclaration.swift`

Lightweight representation of a Swift type.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct TypeDeclaration` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | `String` | - | Type identifier |
| `kind` | `TypeKind` | - | Classification (struct, class, etc.) |
| `line` | `Int` | - | Source line number |
| `members` | `[MemberDeclaration]` | `[]` | Contained members |

## Purpose

Represents a type with its members for:
- Reporting in check mode
- Analyzing member order
- Identifying types needing reorder

Does **not** include syntax node references.

## Related

- [SyntaxTypeDeclaration](SyntaxTypeDeclaration.md) - Syntax-aware version
- [MemberDeclaration](MemberDeclaration.md) - Member type
- [TypeKind](TypeKind.md) - Kind enum
