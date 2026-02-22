# ParseStage

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Parse/ParseStage.swift`

Stage that parses Swift source code into a syntax tree.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ParseStage` |
| **Protocols** | `Stage` |

## Stage Protocol

| Type | Value |
|------|-------|
| `Input` | `ParseInput` |
| `Output` | `ParseOutput` |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `process(_:)` | `ParseInput` | `ParseOutput` | Parse source code |

## Process Steps

1. Parse source using `Parser.parse(source:)`
2. Create `SourceLocationConverter` with file path and syntax tree
3. Return `ParseOutput` with path, syntax, and converter

## Dependencies

| Import | Usage |
|--------|-------|
| `SwiftParser` | `Parser.parse(source:)` |
| `SwiftSyntax` | `SourceLocationConverter` |

## Design Decisions

- **Stateless**: No configuration or dependencies
- **Pure function**: Same input produces same output
- **SwiftSyntax integration**: Uses official Swift parser

## Related

- [ParseInput](ParseInput.md) - Input type
- [ParseOutput](ParseOutput.md) - Output type
- [Stage](../Protocols/Stage.md) - Protocol definition
