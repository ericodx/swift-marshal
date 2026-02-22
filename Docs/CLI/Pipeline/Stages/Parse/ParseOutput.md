# ParseOutput

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Parse/ParseOutput.swift`

Output type containing parsed syntax tree.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ParseOutput` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `path` | `String` | Original file path |
| `syntax` | `SourceFileSyntax` | Parsed syntax tree |
| `locationConverter` | `SourceLocationConverter` | Maps syntax to line numbers |

## Dependencies

| Import | Usage |
|--------|-------|
| `SwiftSyntax` | `SourceFileSyntax`, `SourceLocationConverter` |

## Usage

Consumed by classification stages to discover types and members.

## Related

- [ParseStage](ParseStage.md) - Produces this output
- [ClassifyStage](../Classify/ClassifyStage.md) - Consumes this
- [SyntaxClassifyStage](../Classify/SyntaxClassifyStage.md) - Consumes this
