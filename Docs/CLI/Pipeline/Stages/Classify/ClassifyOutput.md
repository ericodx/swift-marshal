# ClassifyOutput

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Classify/ClassifyOutput.swift`

Output containing discovered type declarations.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ClassifyOutput` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `path` | `String` | Source file path |
| `declarations` | `[TypeDeclaration]` | Discovered types |

## Dependencies

| Import | Usage |
|--------|-------|
| `SwiftSyntax` | Required for model types |

## Usage

Used by check pipeline for reorder analysis without syntax modification.

## Related

- [ClassifyStage](ClassifyStage.md) - Produces this output
- [ReorderStage](../Reorder/ReorderStage.md) - Consumes this
- [TypeDeclaration](../../../Core/Models/TypeDeclaration.md) - Declaration model
