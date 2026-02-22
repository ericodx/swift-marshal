# TypeDiscoveryInfo

**Source**: `Sources/SwiftMarshal/Core/Models/TypeDiscoveryInfo.swift`

Intermediate data captured during type discovery.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct TypeDiscoveryInfo<MemberOutput>` |
| **Protocols** | `Sendable` |
| **Generic** | `MemberOutput: Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `name` | `String` | Type identifier |
| `kind` | `TypeKind` | Classification |
| `position` | `AbsolutePosition` | Position in source |
| `members` | `[MemberOutput]` | Discovered members |
| `memberBlock` | `MemberBlockSyntax` | Syntax node |

## Generic Parameter

`MemberOutput` is the output type from the member builder, allowing this struct to work with both:
- `MemberDeclaration`
- `SyntaxMemberDeclaration`

## Purpose

Carries all information needed by builders to create either:
- `TypeDeclaration` (lightweight)
- `SyntaxTypeDeclaration` (syntax-aware)

## Related

- [UnifiedTypeDiscoveryVisitor](../Visitors/UnifiedTypeDiscoveryVisitor.md) - Creates this type
- [TypeOutputBuilder](../Visitors/Builders/TypeOutputBuilder.md) - Consumes this type
