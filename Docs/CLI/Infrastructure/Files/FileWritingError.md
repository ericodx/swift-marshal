# FileWritingError

**Source**: `Sources/SwiftMarshal/Infrastructure/Files/FileWritingError.swift`

Error type for file write failures.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `enum FileWritingError` |
| **Protocols** | `Error`, `LocalizedError` |

## Cases

| Case | Associated Values | Description |
|------|-------------------|-------------|
| `writeError` | `String` (path), `Error` | Write operation failed |

## Computed Properties

| Property | Type | Description |
|----------|------|-------------|
| `errorDescription` | `String?` | User-friendly error message |

## Error Messages

| Case | Message Format |
|------|----------------|
| `writeError` | `"Failed to write '{path}': {underlying error}"` |

## Design Decisions

- **Single case**: Write failures are always system errors
- **Path preserved**: Shows which file failed
- **Underlying error preserved**: Wraps original system error
- **LocalizedError**: Provides `errorDescription` for display

## Related

- [FileIOActor](FileIOActor.md) - Throws this error
