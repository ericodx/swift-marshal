# FixCommand

**Source**: `Sources/SwiftMarshal/Commands/FixCommand.swift`

Applies member reordering to source files.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct FixCommand` |
| **Protocol** | `AsyncParsableCommand` |

## Properties

| Property | Type | Attribute | Description |
|----------|------|-----------|-------------|
| `files` | `[String]` | `@Argument` | Input file paths |
| `config` | `String?` | `@Option` | Configuration file path |
| `dryRun` | `Bool` | `@Flag` | Preview without writing |
| `quiet` | `Bool` | `@Flag` | Suppress per-file output |

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
5. Process all files via `coordinator.fixFiles(files, dryRun:)`
6. Collect modified file paths
7. If not quiet, print each modified file
8. Print summary
9. If dry-run and files modified, throw `ExitCode(1)`

## Dependencies

| Dependency | Layer | Usage |
|------------|-------|-------|
| `FileIOActor` | Infrastructure | Async file read/write |
| `FileReader` | Infrastructure | Sync file reading (for config) |
| `ConfigurationService` | Core | Load and parse configuration |
| `PipelineCoordinator` | Pipeline | Orchestrate parallel processing |

## Design Decisions

- **Dry-run mode**: Safe preview, exits 1 if changes would occur (CI-friendly)
- **Parallel processing**: Files processed concurrently, writes serialized by actor
- **No confirmation prompt**: Designed for automation, use dry-run for safety

## Related

- [CheckCommand](CheckCommand.md) - Identifies issues without fixing
