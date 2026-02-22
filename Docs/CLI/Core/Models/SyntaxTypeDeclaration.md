# SyntaxTypeDeclaration

**Source**: `Sources/SwiftMarshal/Core/Models/SyntaxTypeDeclaration.swift`

Type representation with syntax node reference for rewriting.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct SyntaxTypeDeclaration` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `name` | `String` | Type identifier |
| `kind` | `TypeKind` | Classification |
| `line` | `Int` | Source line number |
| `members` | `[SyntaxMemberDeclaration]` | Members with syntax refs |
| `memberBlock` | `MemberBlockSyntax` | SwiftSyntax member block |

## Purpose

Provides full syntax context needed for:
- Creating rewrite plans
- Matching types during AST rewriting
- Accessing member block for modification

## Related

- [TypeDeclaration](TypeDeclaration.md) - Lightweight version
- [SyntaxMemberDeclaration](SyntaxMemberDeclaration.md) - Member type
