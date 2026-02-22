# FileReader

**Source**: `Sources/SwiftMarshal/Infrastructure/Files/FileReader.swift`

Asynchronous file reader conforming to `FileReading` protocol with Swift 6 concurrency support.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct FileReader` |
| **Protocols** | `FileReading` |

## Methods

| Method | Parameters | Returns | Throws | Description |
|--------|------------|---------|--------|-------------|
| `read(at:)` | `path: String` | `String` | `FileReadingError` | Read file contents asynchronously |

## Read Operation

1. Create URL from path
2. Check file existence via `FileManager`
3. If not found, throw `FileReadingError.fileNotFound`
4. Read contents as UTF-8 string asynchronously
5. If read fails, throw `FileReadingError.readError`

## Protocol Conformance

Conforms to `FileReading`, enabling:
- Dependency injection in `ConfigurationService`
- Mock substitution in unit tests
- Async/await pattern throughout the application

## Usage

Used by `ConfigurationService` for loading configuration files asynchronously during command execution.

## Swift 6 Conformance

- ✓ **Async/await**: Uses modern Swift concurrency
- ✓ **Thread-safe**: Safe for concurrent access
- ✓ **Sendable**: Can be shared across actor boundaries
- ✓ **Strict mode**: Compatible with Swift 6 strict concurrency

## Related

- [FileReading](../Protocols/FileReading.md) - Protocol definition
- [FileIOActor](FileIOActor.md) - Actor-based alternative
- [FileReadingError](FileReadingError.md) - Error type
