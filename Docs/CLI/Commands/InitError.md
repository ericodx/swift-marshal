# InitError

**Source**: `Sources/SwiftMarshal/Commands/InitError.swift`

Error type for `InitCommand` failures.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `enum InitError` |
| **Protocols** | `Error`, `LocalizedError` |

## Cases

| Case | Associated Value | Description |
|------|------------------|-------------|
| `configAlreadyExists` | `String` (path) | File exists without force flag |

## Computed Properties

| Property | Type | Description |
|----------|------|-------------|
| `errorDescription` | `String?` | User-friendly error message |

## Design Decisions

- **Enum with associated values**: Type-safe error with context
- **LocalizedError**: Provides `errorDescription` for ArgumentParser
- **Single case**: Minimal error type, extend as needed

## Related

- [InitCommand](InitCommand.md) - Command that uses this error type
