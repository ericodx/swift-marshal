# FileReadingError

**Source**: `Sources/SwiftMarshal/Infrastructure/Files/FileReadingError.swift`

Error type for file read failures.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `enum FileReadingError` |
| **Protocols** | `Error`, `LocalizedError` |

## Cases

| Case | Associated Values | Description |
|------|-------------------|-------------|
| `fileNotFound` | `String` (path) | File does not exist |
| `readError` | `String` (path), `Error` | Read operation failed |

## Computed Properties

| Property | Type | Description |
|----------|------|-------------|
| `errorDescription` | `String?` | User-friendly error message |

## Error Messages

| Case | Message Format |
|------|----------------|
| `fileNotFound` | `"File not found: {path}"` |
| `readError` | `"Failed to read '{path}': {underlying error}"` |

## Design Decisions

- **Path in all cases**: Enables debugging by showing which file failed
- **Underlying error preserved**: `readError` wraps the original system error
- **LocalizedError**: Provides `errorDescription` for display

## Related

- [FileReader](FileReader.md) - Throws this error
- [FileIOActor](FileIOActor.md) - Throws this error
