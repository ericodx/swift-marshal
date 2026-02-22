# InitCommand

**Source**: `Sources/SwiftMarshal/Commands/InitCommand.swift`

Creates the default configuration file.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct InitCommand` |
| **Protocol** | `ParsableCommand` (synchronous) |

## Properties

| Property | Type | Attribute | Description |
|----------|------|-----------|-------------|
| `force` | `Bool` | `@Flag` | Overwrite existing file |
| `configFileName` | `String` | `static let` | Fixed filename: `.swift-marshal.yaml` |

## Methods

| Method | Visibility | Description |
|--------|------------|-------------|
| `run()` | public | Main execution logic |
| `defaultConfigContent` | private | Returns default YAML content |

## Execution Flow

1. Build config path from current directory + filename
2. Check if file exists using `FileManager`
3. If exists and no `--force`, throw `InitError.configAlreadyExists`
4. Write `defaultConfigContent` to file
5. Print success message

## Dependencies

| Dependency | Usage |
|------------|-------|
| `Foundation.FileManager` | File existence check, current directory |
| `ArgumentParser` | CLI argument parsing |

## Design Decisions

- **Synchronous**: No async I/O needed for single file write
- **No configuration injection**: Creates hardcoded default content
- **Current directory only**: Does not support custom output path

## Related

- [InitError](InitError.md) - Error type used by this command
