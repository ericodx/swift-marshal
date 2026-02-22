# SyntaxClassifyStage

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Classify/SyntaxClassifyStage.swift`

Stage that discovers types with syntax references for rewriting.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct SyntaxClassifyStage` |
| **Protocols** | `Stage` |

## Stage Protocol

| Type | Value |
|------|-------|
| `Input` | `ParseOutput` |
| `Output` | `SyntaxClassifyOutput` |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `process(_:)` | `ParseOutput` | `SyntaxClassifyOutput` | Classify with syntax |

## Process Steps

1. Create `UnifiedTypeDiscoveryVisitor.forSyntaxDeclarations()`
2. Walk syntax tree with visitor
3. Return `SyntaxClassifyOutput` with syntax tree and declarations

## Dependencies

| Import | Usage |
|--------|-------|
| `SwiftSyntax` | Syntax tree walking |

## Design Decisions

- **Fix mode**: Used when rewriting is needed
- **Syntax preservation**: Retains original syntax tree
- **Member syntax**: Declarations include `MemberBlockItemSyntax` references

## Related

- [SyntaxClassifyOutput](SyntaxClassifyOutput.md) - Output type
- [UnifiedTypeDiscoveryVisitor](../../../Core/Visitors/UnifiedTypeDiscoveryVisitor.md) - AST visitor
- [ClassifyStage](ClassifyStage.md) - Alternative for check mode
