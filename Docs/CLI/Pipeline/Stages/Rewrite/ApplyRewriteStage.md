# ApplyRewriteStage

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Rewrite/ApplyRewriteStage.swift`

Stage that applies rewrite plans to produce reordered source.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ApplyRewriteStage` |
| **Protocols** | `Stage` |

## Stage Protocol

| Type | Value |
|------|-------|
| `Input` | `RewritePlanOutput` |
| `Output` | `RewriteOutput` |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `process(_:)` | `RewritePlanOutput` | `RewriteOutput` | Apply rewrites |

## Process Steps

1. Check if `input.needsRewriting` is false
   - Return unmodified source with `modified: false`
2. Create `MemberReorderingRewriter` with plans
3. Call `rewriter.rewrite()` on syntax tree
4. Return `RewriteOutput` with rewritten source and `modified: true`

## Dependencies

| Import | Usage |
|--------|-------|
| `SwiftSyntax` | Syntax rewriting |

## Design Decisions

- **Early exit**: Skip rewriting if no changes needed
- **Rewriter delegation**: Actual rewriting in `MemberReorderingRewriter`
- **Source extraction**: Uses `.description` for source string

## Related

- [RewritePlanOutput](RewritePlanOutput.md) - Input type
- [RewriteOutput](RewriteOutput.md) - Output type
- [MemberReorderingRewriter](MemberReorderingRewriter.md) - Syntax rewriter
