# FileIOActor

**Source**: `Sources/SwiftMarshal/Infrastructure/Files/FileIOActor.swift`

Actor for thread-safe async file I/O operations.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `actor FileIOActor` |

## Methods

| Method | Parameters | Returns | Throws | Description |
|--------|------------|---------|--------|-------------|
| `read(at:)` | `path: String` | `String` | `FileReadingError` | Read file contents |
| `write(_:to:)` | `content: String`, `path: String` | `Void` | `FileWritingError` | Write content to file |

## Read Operation

1. Create URL from path
2. Check file existence via `FileManager`
3. If not found, throw `FileReadingError.fileNotFound`
4. Read contents as UTF-8 string
5. If read fails, throw `FileReadingError.readError`

## Write Operation

1. Create URL from path
2. Write content atomically as UTF-8
3. If write fails, throw `FileWritingError.writeError`

## Actor Benefits

- **Thread safety**: All operations serialized within actor
- **Async interface**: Callers use `await` for non-blocking access
- **Concurrent file processing**: Multiple files can be processed in parallel TaskGroups while individual file operations remain safe

## Usage

```text
PipelineCoordinator
    │
    ├── Task 1 ──await──► FileIOActor.read(fileA)
    ├── Task 2 ──await──► FileIOActor.read(fileB)
    └── Task N ──await──► FileIOActor.read(fileN)
```

## Related

- [FileReader](FileReader.md) - Synchronous alternative
- [FileReadingError](FileReadingError.md) - Read error type
- [FileWritingError](FileWritingError.md) - Write error type
