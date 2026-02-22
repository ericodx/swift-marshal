# FileReading

**Source**: `Sources/SwiftMarshal/Infrastructure/Protocols/FileReading.swift`

Protocol for asynchronous file reading abstraction with Swift 6 concurrency support.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `protocol FileReading` |

## Required Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `read(at:)` | `path: String` | `String` | Read file contents asynchronously |

## Implementations

| Type | Description |
|------|-------------|
| `FileReader` | Production implementation |
| `MockFileReader` | Test implementation for unit tests |

## Usage

Injected into `ConfigurationService` to enable:
- Real async file reading in production
- Mock file content in tests with async support

## Design Decisions

- **Async interface**: Supports Swift 6 strict concurrency
- **Minimal interface**: Single method for single responsibility
- **Throws**: Allows implementations to signal failures
- **Sendable**: Protocol is implicitly Sendable for thread safety

## Swift 6 Conformance

- ✓ **Async/await**: Uses modern Swift concurrency
- ✓ **Thread-safe**: Compatible with Swift 6 strict mode
- ✓ **Sendable**: Safe to share across concurrency boundaries

## Related

- [FileReader](../Files/FileReader.md) - Production implementation
