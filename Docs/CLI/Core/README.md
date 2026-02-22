# Core Documentation

Implementation documentation for Swift Marshal Core layer.

## Overview

The Core layer contains all business logic: domain models, configuration handling, AST visitors, and the reordering engine.

## Structure

```text
Sources/SwiftMarshal/Core/
├── Configuration/       # YAML parsing and configuration models
├── Models/              # Domain models for types and members
├── Reordering/          # Member reordering algorithm
└── Visitors/            # SwiftSyntax AST visitors
    └── Builders/        # Output builders for visitors
```

## Modules

| Module | Description |
|--------|-------------|
| [Configuration](Configuration/README.md) | YAML configuration loading, parsing, and mapping |
| [Models](Models/README.md) | Domain models representing Swift types and members |
| [Reordering](Reordering/README.md) | Rule-based member reordering engine |
| [Visitors](Visitors/README.md) | AST traversal and member discovery |

## Layer Responsibilities

- Parse and validate configuration files
- Define domain models for Swift type structures
- Traverse AST to discover types and members
- Apply ordering rules to determine correct member sequence
- Provide building blocks for Pipeline stages
