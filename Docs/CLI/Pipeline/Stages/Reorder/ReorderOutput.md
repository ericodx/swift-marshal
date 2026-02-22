# ReorderOutput

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Reorder/ReorderOutput.swift`

Output containing reorder analysis results.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ReorderOutput` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `path` | `String` | Source file path |
| `results` | `[TypeReorderResult]` | Per-type results |

## Usage

Consumed by `ReorderReportStage` for report generation or by `PipelineCoordinator` for check results.

## Related

- [ReorderStage](ReorderStage.md) - Produces this output
- [ReorderReportStage](ReorderReportStage.md) - Consumes for reporting
- [TypeReorderResult](TypeReorderResult.md) - Result model
