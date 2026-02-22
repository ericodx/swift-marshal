# Files Module

File system operations and error types.

## Source Structure

```text
Sources/SwiftMarshal/Infrastructure/Files/
├── FileIOActor.swift
├── FileReader.swift
├── FileReadingError.swift
└── FileWritingError.swift
```

## Documents

| Document | Description |
|----------|-------------|
| [FileIOActor](FileIOActor.md) | Actor for async file I/O |
| [FileReader](FileReader.md) | Synchronous file reader |
| [FileReadingError](FileReadingError.md) | Read operation errors |
| [FileWritingError](FileWritingError.md) | Write operation errors |

## Two Readers

The module provides two file reading implementations:

| Type | Sync/Async | Use Case |
|------|------------|----------|
| `FileReader` | Synchronous | Configuration loading |
| `FileIOActor` | Async (actor) | Parallel source file processing |

## Error Handling

Both readers throw specific error types with path information for debugging.
