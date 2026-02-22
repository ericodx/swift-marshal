# TypeRewritePlan

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Rewrite/TypeRewritePlan.swift`

Plan for rewriting members within a single type.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct TypeRewritePlan` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `typeName` | `String` | Type name |
| `kind` | `TypeKind` | Type kind |
| `line` | `Int` | Declaration line |
| `originalMembers` | `[SyntaxMemberDeclaration]` | Original order |
| `reorderedMembers` | `[IndexedSyntaxMember]` | Target order |

## Computed Properties

| Property | Type | Description |
|----------|------|-------------|
| `needsRewriting` | `Bool` | Whether order differs |

## needsRewriting Logic

Compares member kinds between original and reordered:
- Extracts `declaration.kind` from each member
- Returns `true` if sequences differ

## Differences from TypeReorderResult

| Aspect | TypeReorderResult | TypeRewritePlan |
|--------|-------------------|-----------------|
| Members | `MemberDeclaration` | `SyntaxMemberDeclaration` |
| Reordered | `[MemberDeclaration]` | `[IndexedSyntaxMember]` |
| Use case | Check/report | Rewriting |

## Usage

Created by `RewritePlanStage`, consumed by `MemberReorderingRewriter`.

## Related

- [RewritePlanStage](RewritePlanStage.md) - Creates these plans
- [MemberReorderingRewriter](MemberReorderingRewriter.md) - Uses these plans
- [IndexedSyntaxMember](IndexedSyntaxMember.md) - Reordered member type
- [TypeReorderResult](../Reorder/TypeReorderResult.md) - Similar for check mode
