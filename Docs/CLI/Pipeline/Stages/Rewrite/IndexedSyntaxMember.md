# IndexedSyntaxMember

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Rewrite/IndexedSyntaxMember.swift`

Member declaration with its original index in the type.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct IndexedSyntaxMember` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `member` | `SyntaxMemberDeclaration` | Member with syntax |
| `originalIndex` | `Int` | Position in original order |

## Purpose

Tracks where a member was originally positioned so the rewriter can:
- Match members to their original syntax nodes
- Handle trivia transfer when first member moves

## Usage

Created by `RewritePlanStage` when mapping reordered declarations back to syntax.

## Related

- [RewritePlanStage](RewritePlanStage.md) - Creates these
- [TypeRewritePlan](TypeRewritePlan.md) - Contains reordered members
- [SyntaxMemberDeclaration](../../../Core/Models/SyntaxMemberDeclaration.md) - Member model
