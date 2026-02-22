# Infrastructure Documentation

Implementation documentation for Swift Marshal Infrastructure layer with Swift 6 concurrency support.

## Overview

The Infrastructure layer handles external concerns, primarily async file system operations. It provides abstractions that isolate the rest of the application from I/O details while ensuring thread safety.

## Structure

```text
Sources/SwiftMarshal/Infrastructure/
├── Files/
│   ├── FileIOActor.swift
│   ├── FileReader.swift
│   ├── FileReadingError.swift
│   └── FileWritingError.swift
└── Protocols/
    └── FileReading.swift
```

## Modules

| Module | Description |
|--------|-------------|
| [Files](Files/README.md) | Async file system operations and error types |
| [Protocols](Protocols/README.md) | Abstractions for dependency injection |

## Layer Responsibilities

- Encapsulate async file system access
- Provide thread-safe file I/O via actors
- Define error types for I/O failures
- Enable testability through protocol abstractions
- Ensure Swift 6 strict concurrency compliance

## Design Principles

- **Actor isolation**: `FileIOActor` ensures thread-safe file operations
- **Protocol abstraction**: `FileReading` enables async mock injection in tests
- **Error specificity**: Dedicated error types with context information
- **Async-first**: All I/O operations use async/await pattern
- **Sendable compliance**: Safe to share across concurrency boundaries

## Swift 6 Conformance

- ✓ **Actor-based**: File operations isolated in `FileIOActor`
- ✓ **Async protocols**: `FileReading` uses async/await
- ✓ **Sendable types**: All infrastructure types are Sendable
- ✓ **Strict mode**: Compatible with Swift 6 strict concurrency
