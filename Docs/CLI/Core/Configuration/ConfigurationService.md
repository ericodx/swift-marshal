# ConfigurationService

**Source**: `Sources/SwiftMarshal/Core/Configuration/ConfigurationService.swift`

High-level facade for asynchronously loading configuration files with Swift 6 concurrency support.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ConfigurationService` |

## Dependencies

| Dependency | Type | Description |
|------------|------|-------------|
| `fileReader` | `FileReading` | Reads file contents asynchronously |
| `loader` | `ConfigurationLoader` | Parses YAML content |
| `mapper` | `ConfigurationMapper` | Maps raw to validated config |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `configFileName` | `String` | Fixed: `.swift-marshal.yaml` |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `load(from:)` | `directory: String?` | `Configuration` | Load from directory, searching upward asynchronously |
| `load(configFile:)` | `String` | `Configuration` | Load from specific file path asynchronously |
| `load(configPath:)` | `String?` | `Configuration` | Load from path or search asynchronously |

## Private Methods

| Method | Description |
|--------|-------------|
| `loadFromFile(at:)` | Read, parse, and map a config file asynchronously |
| `findConfigFile(startingFrom:)` | Search directory tree for config file |

## Search Algorithm

When no explicit path is provided:

1. Start from current directory (or specified directory)
2. Check for `.swift-marshal.yaml`
3. If not found, move to parent directory
4. Repeat until root is reached
5. If not found anywhere, return `Configuration.default`

## Design Decisions

- **Facade pattern**: Hides complexity of loader/mapper chain
- **Dependency injection**: All dependencies injectable for testing
- **Upward search**: Supports monorepo structures with config at root
- **Graceful fallback**: Returns default config if none found
- **Async interface**: Supports Swift 6 strict concurrency

## Swift 6 Conformance

- ✓ **Async/await**: All methods use modern Swift concurrency
- ✓ **Thread-safe**: Safe for concurrent access
- ✓ **Sendable**: Can be shared across actor boundaries
- ✓ **Strict mode**: Compatible with Swift 6 strict concurrency

## Related

- [ConfigurationLoader](ConfigurationLoader.md) - YAML parsing
- [ConfigurationMapper](ConfigurationMapper.md) - Validation and mapping
- [FileReading](../../Infrastructure/Protocols/FileReading.md) - Async file reading
