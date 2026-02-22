# RewriteOutput

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Rewrite/RewriteOutput.swift`

Final output containing rewritten source code.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct RewriteOutput` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `path` | `String` | Source file path |
| `source` | `String` | Rewritten source code |
| `modified` | `Bool` | Whether changes were made |

## Usage

Used by `PipelineCoordinator.fixFiles()` to:
- Determine if file should be written (when `modified == true`)
- Get source content to write

## Related

- [ApplyRewriteStage](ApplyRewriteStage.md) - Produces this output
- [PipelineCoordinator](../../PipelineCoordinator.md) - Consumes for file writing
