# ReportOutput

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Report/ReportOutput.swift`

Output containing a human-readable report.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ReportOutput` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `path` | `String` | Source file path |
| `text` | `String` | Formatted report text |
| `declarationCount` | `Int` | Number of types analyzed |

## Usage

Final output of check pipeline, printed to console.

## Related

- [ReorderReportStage](../Reorder/ReorderReportStage.md) - Produces this output
