# MemberDeclaration

**Source**: `Sources/SwiftMarshal/Core/Models/MemberDeclaration.swift`

Lightweight representation of a type member.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct MemberDeclaration` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | `String` | - | Member identifier |
| `kind` | `MemberKind` | - | Classification (property, method, etc.) |
| `line` | `Int` | - | Source line number |
| `visibility` | `Visibility` | `.internal` | Access level |
| `isAnnotated` | `Bool` | `false` | Has attributes |

## Purpose

Represents the essential information about a member needed for:
- Reporting violations in check mode
- Determining reorder requirements
- Rule matching

Does **not** include syntax node references, making it suitable for lightweight operations.

## Related

- [SyntaxMemberDeclaration](SyntaxMemberDeclaration.md) - Syntax-aware wrapper
- [MemberKind](MemberKind.md) - Kind enum
- [Visibility](Visibility.md) - Visibility enum
