# ReorderStage

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Reorder/ReorderStage.swift`

Stage that analyzes member ordering against configuration.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ReorderStage` |
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
| `Input` | `ClassifyOutput` |
| `Output` | `ReorderOutput` |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `process(_:)` | `ClassifyOutput` | `ReorderOutput` | Analyze ordering |

## Process Steps

1. Iterate over each type declaration
2. Call `engine.reorder()` on members
3. Create `TypeReorderResult` with original and reordered
4. Return `ReorderOutput` with all results

## Design Decisions

- **Configuration injection**: Rules passed via initializer
- **Engine delegation**: Reordering logic in `ReorderEngine`
- **Check mode**: Analysis only, no syntax modification

## Related

- [ReorderOutput](ReorderOutput.md) - Output type
- [ReorderEngine](../../../Core/Reordering/ReorderEngine.md) - Reordering logic
- [TypeReorderResult](TypeReorderResult.md) - Result model
