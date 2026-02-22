# RewritePlanOutput

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Rewrite/RewritePlanOutput.swift`

Output containing rewrite plans for all types.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct RewritePlanOutput` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `path` | `String` | Source file path |
| `syntax` | `SourceFileSyntax` | Original syntax tree |
| `plans` | `[TypeRewritePlan]` | Per-type plans |

## Computed Properties

| Property | Type | Description |
|----------|------|-------------|
| `needsRewriting` | `Bool` | Any plan needs rewriting |

## Dependencies

| Import | Usage |
|--------|-------|
| `SwiftSyntax` | `SourceFileSyntax` |

## Usage

Passed to `ApplyRewriteStage` which uses:
- `syntax` as input to rewriter
- `plans` to configure rewriter
- `needsRewriting` for early exit

## Related

- [RewritePlanStage](RewritePlanStage.md) - Produces this output
- [ApplyRewriteStage](ApplyRewriteStage.md) - Consumes this
- [TypeRewritePlan](TypeRewritePlan.md) - Plan model
