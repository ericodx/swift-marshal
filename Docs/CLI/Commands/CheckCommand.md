# CheckCommand

**Source**: `Sources/SwiftMarshal/Commands/CheckCommand.swift`

Analyzes files and reports ordering violations.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct CheckCommand` |
| **Protocol** | `AsyncParsableCommand` |

## Properties

| Property | Type | Attribute | Description |
|----------|------|-----------|-------------|
| `files` | `[String]` | `@Argument` | Input file paths |
| `config` | `String?` | `@Option` | Configuration file path |
| `quiet` | `Bool` | `@Flag` | Suppress detailed output |

## Methods

| Method | Visibility | Description |
|--------|------------|-------------|
| `run()` | public | Main async execution |
| `printSummary(...)` | private | Formats and prints result summary |

## Execution Flow

1. Create `FileIOActor` for async file operations
2. Create `FileReader` for configuration loading
3. Load configuration via `ConfigurationService`
4. Create `PipelineCoordinator` with dependencies
5. Process all files in parallel via `coordinator.checkFiles()`
6. Iterate results, aggregate statistics
7. If not quiet, print detailed report per file using `ReorderReportStage`
8. Print summary
9. Throw `ExitCode(1)` if any files need reordering

## Dependencies

| Dependency | Layer | Usage |
|------------|-------|-------|
| `FileIOActor` | Infrastructure | Async file reading |
| `FileReader` | Infrastructure | Sync file reading (for config) |
| `ConfigurationService` | Core | Load and parse configuration |
| `PipelineCoordinator` | Pipeline | Orchestrate parallel processing |
| `ReorderReportStage` | Pipeline | Format check results |

## Design Decisions

- **Async execution**: Enables parallel file processing
- **Two file readers**: `FileIOActor` for parallel source files, `FileReader` for config
- **Exit code 1**: Enables CI integration (fail build on violations)
- **Quiet mode**: Scriptable output for tooling integration

## Related

- [FixCommand](FixCommand.md) - Applies the fixes that check identifies
