# SyntaxMemberDeclaration

**Source**: `Sources/SwiftMarshal/Core/Models/SyntaxMemberDeclaration.swift`

Member representation with syntax node reference for rewriting.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct SyntaxMemberDeclaration` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `declaration` | `MemberDeclaration` | Lightweight member info |
| `syntax` | `MemberBlockItemSyntax` | SwiftSyntax node reference |

## Purpose

Extends `MemberDeclaration` with syntax node reference needed for:
- AST manipulation in fix mode
- Preserving trivia during rewriting
- Node identification via `syntax.id`

## Design Decision

Composition over inheritance: wraps `MemberDeclaration` rather than duplicating its properties.

## Related

- [MemberDeclaration](MemberDeclaration.md) - Wrapped lightweight model
- [SyntaxTypeDeclaration](SyntaxTypeDeclaration.md) - Parent container
