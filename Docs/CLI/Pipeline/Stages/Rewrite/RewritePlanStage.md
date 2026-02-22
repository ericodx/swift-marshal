# RewritePlanStage

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Rewrite/RewritePlanStage.swift`

Stage that creates rewrite plans from syntax classifications.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct RewritePlanStage` |
| **Protocols** | `Stage` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `engine` | `ReorderEngine` | Reordering logic |

## Initializer

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `configuration` | `Configuration` | `.default` | Ordering rules |

## Stage Protocol

| Type | Value |
|------|-------|
| `Input` | `SyntaxClassifyOutput` |
| `Output` | `RewritePlanOutput` |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `process(_:)` | `SyntaxClassifyOutput` | `RewritePlanOutput` | Create plans |

## Private Methods

| Method | Description |
|--------|-------------|
| `mapToIndexedMembers(reorderedDeclarations:originalMembers:)` | Map reordered to indexed |

## Process Steps

1. Iterate over each `SyntaxTypeDeclaration`
2. Call `engine.reorder()` on member declarations
3. Map reordered declarations to `IndexedSyntaxMember`
4. Create `TypeRewritePlan` with original and reordered
5. Return `RewritePlanOutput` with all plans

## Mapping Logic

Uses line numbers as keys to match reordered `MemberDeclaration` back to original `SyntaxMemberDeclaration`.

## Design Decisions

- **Line-based mapping**: Reliable way to match declarations to syntax
- **Index tracking**: Preserves original position for trivia handling
- **Engine delegation**: Reordering logic in `ReorderEngine`

## Related

- [SyntaxClassifyOutput](../Classify/SyntaxClassifyOutput.md) - Input type
- [RewritePlanOutput](RewritePlanOutput.md) - Output type
- [ReorderEngine](../../../Core/Reordering/ReorderEngine.md) - Reordering logic
- [IndexedSyntaxMember](IndexedSyntaxMember.md) - Mapped member
