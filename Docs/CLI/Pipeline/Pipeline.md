# Pipeline

**Source**: `Sources/SwiftMarshal/Pipeline/Pipeline.swift`

Generic compositor that chains two stages into a single stage.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct Pipeline<S1: Stage, S2: Stage>` |
| **Protocols** | `Stage`, `Sendable` |
| **Constraint** | `S1.Output == S2.Input` |

## Type Aliases

| Alias | Definition | Description |
|-------|------------|-------------|
| `Input` | `S1.Input` | Input type of first stage |
| `Output` | `S2.Output` | Output type of second stage |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `first` | `S1` | First stage in chain |
| `second` | `S2` | Second stage in chain |

## Initializer

| Parameter | Type | Description |
|-----------|------|-------------|
| `_` | `S1` | First stage |
| `_` | `S2` | Second stage |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `process(_:)` | `Input` | `Output` | Process through both stages |

## Process Flow

1. Call `first.process(input)` to get intermediate result
2. Call `second.process(intermediate)` to get final output
3. Return final output

## Design Decisions

- **Generic composition**: Any two stages with matching types can be composed
- **Type safety**: Compiler enforces `S1.Output == S2.Input`
- **Sendable**: Enables concurrent usage
- **Transparent chaining**: Composed pipeline is itself a Stage

## Related

- [Stage](Stages/Protocols/Stage.md) - Protocol definition with `then()` method
- [PipelineCoordinator](PipelineCoordinator.md) - Uses composed pipelines
