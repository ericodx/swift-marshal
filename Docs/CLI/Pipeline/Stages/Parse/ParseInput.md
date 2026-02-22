# ParseInput

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Parse/ParseInput.swift`

Input type for the parse stage.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ParseInput` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `path` | `String` | File path for error reporting |
| `source` | `String` | Source code to parse |

## Usage

Created by `PipelineCoordinator` after reading file contents.

## Related

- [ParseStage](ParseStage.md) - Consumes this input
- [ParseOutput](ParseOutput.md) - Produced output
