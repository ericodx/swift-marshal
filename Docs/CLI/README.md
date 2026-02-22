# CLI Documentation

Documentation for the Swift Marshal command-line interface with Swift 6 strict concurrency support.

## Source Structure

```text
Sources/SwiftMarshal/
├── SwiftMarshal.swift    # Entry point (@main)
├── Version.swift              # Version management
├── Commands/                  # CLI commands with async/await
├── Core/                      # Domain models and logic
├── Infrastructure/            # Async file I/O abstractions
└── Pipeline/                  # Processing pipeline
```

## Documentation Modules

| Module | Description |
|--------|-------------|
| [SwiftMarshal](SwiftMarshal.md) | CLI entry point (`@main`) |
| [Version](Version.md) | Version management |
| [Commands](Commands/README.md) | CLI commands with Swift 6 concurrency |
| [Core](Core/README.md) | Configuration, models, visitors |
| [Infrastructure](Infrastructure/README.md) | Async file reading and writing |
| [Pipeline](Pipeline/README.md) | Stage-based processing |

## Quick Links

| Audience | Document |
|----------|----------|
| **Users** | [Commands/Usage.md](Commands/Usage.md) |
| **Developers** | Module READMEs above |

## Swift 6 Conformance

This CLI is fully compliant with Swift 6 strict concurrency:

- ✓ **Async/await**: Modern concurrency throughout
- ✓ **Actor isolation**: Thread-safe file operations
- ✓ **Sendable**: Safe data sharing across boundaries
- ✓ **Strict mode**: No @unchecked Sendable where avoidable

## Architecture Overview

### Layer Dependencies

```mermaid
flowchart LR
    Commands --> Pipeline
    Commands --> Infrastructure
    Pipeline --> Core
    Pipeline --> Infrastructure
```

### Command Structure

```mermaid
flowchart LR
    SS[SwiftMarshal] --> IC[InitCommand]
    SS --> CC[CheckCommand]
    SS --> FC[FixCommand]
```

### Check Pipeline

```mermaid
flowchart LR
    CC[CheckCommand] --> PC[PipelineCoordinator]
    PC --> FIO[FileIOActor]

    subgraph Stages
        PS[ParseStage] --> CS[ClassifyStage]
        CS --> RS[ReorderStage]
    end

    PC --> PS
    RS --> RE[ReorderEngine]
    CS --> V[Visitors]
```

### Fix Pipeline

```mermaid
flowchart LR
    FC[FixCommand] --> PC[PipelineCoordinator]
    PC --> FIO[FileIOActor]

    subgraph Stages
        PS[ParseStage] --> SCS[SyntaxClassifyStage]
        SCS --> RPS[RewritePlanStage]
        RPS --> ARS[ApplyRewriteStage]
    end

    PC --> PS
    RPS --> RE[ReorderEngine]
    SCS --> V[Visitors]
```
