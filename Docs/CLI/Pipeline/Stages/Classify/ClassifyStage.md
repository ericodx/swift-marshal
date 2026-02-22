# ClassifyStage

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Classify/ClassifyStage.swift`

Stage that discovers type declarations for reorder analysis.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ClassifyStage` |
| **Protocols** | `Stage` |

## Stage Protocol

| Type | Value |
|------|-------|
| `Input` | `ParseOutput` |
| `Output` | `ClassifyOutput` |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `process(_:)` | `ParseOutput` | `ClassifyOutput` | Classify types |

## Process Steps

1. Create `UnifiedTypeDiscoveryVisitor.forDeclarations()`
2. Walk syntax tree with visitor
3. Return `ClassifyOutput` with discovered declarations

## Dependencies

| Import | Usage |
|--------|-------|
| `SwiftSyntax` | Syntax tree walking |

## Design Decisions

- **Check mode**: Used when only analysis is needed
- **Lightweight output**: Does not retain syntax references
- **Visitor delegation**: Classification logic in visitor

## Related

- [ClassifyOutput](ClassifyOutput.md) - Output type
- [UnifiedTypeDiscoveryVisitor](../../../Core/Visitors/UnifiedTypeDiscoveryVisitor.md) - AST visitor
- [SyntaxClassifyStage](SyntaxClassifyStage.md) - Alternative for fix mode
