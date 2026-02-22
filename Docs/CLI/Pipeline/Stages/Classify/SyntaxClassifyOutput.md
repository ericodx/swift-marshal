# SyntaxClassifyOutput

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Classify/SyntaxClassifyOutput.swift`

Output containing declarations with syntax references.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct SyntaxClassifyOutput` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `path` | `String` | Source file path |
| `syntax` | `SourceFileSyntax` | Original syntax tree |
| `declarations` | `[SyntaxTypeDeclaration]` | Types with syntax refs |

## Dependencies

| Import | Usage |
|--------|-------|
| `SwiftSyntax` | `SourceFileSyntax` |

## Differences from ClassifyOutput

| Aspect | ClassifyOutput | SyntaxClassifyOutput |
|--------|----------------|----------------------|
| Syntax tree | Not retained | Retained |
| Declarations | `TypeDeclaration` | `SyntaxTypeDeclaration` |
| Use case | Check only | Rewriting |

## Usage

Used by fix pipeline when syntax tree modification is needed.

## Related

- [SyntaxClassifyStage](SyntaxClassifyStage.md) - Produces this output
- [RewritePlanStage](../Rewrite/RewritePlanStage.md) - Consumes this
- [SyntaxTypeDeclaration](../../../Core/Models/SyntaxTypeDeclaration.md) - Declaration model
