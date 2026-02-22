# CLI Commands

This document describes the command-line interface of Swift Marshal, including all available commands, their options, and behaviors.

## Table of Contents

- [Overview](#overview)
- [Entry Point](#entry-point)
- [Commands](#commands)
  - [init](#init)
  - [check](#check)
  - [fix](#fix)
- [Exit Codes](#exit-codes)
- [Configuration Loading](#configuration-loading)

## Overview

Swift Marshal provides three commands for managing Swift code structure:

| Command | Purpose |
|---------|---------|
| `init` | Create a default configuration file |
| `check` | Analyze files and report ordering violations |
| `fix` | Apply member reordering to files |

## Entry Point

The CLI entry point is defined in `SwiftMarshal.swift`:

| Property | Value |
|----------|-------|
| **Command name** | `swift-marshal` |
| **Current version** | 1.0.0 |
| **Protocol** | `AsyncParsableCommand` |
| **Subcommands** | `InitCommand`, `CheckCommand`, `FixCommand` |

The root command provides help and version information but delegates all operations to subcommands.

## Commands

### init

Creates a default `.swift-marshal.yaml` configuration file in the current directory.

**File**: `InitCommand.swift`

#### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `--force` | Flag | `false` | Overwrite existing configuration file |

#### Behavior

```mermaid
flowchart TD
    A[Start] --> B{Config file exists?}
    B -->|No| D[Write default config]
    B -->|Yes| C{--force flag?}
    C -->|Yes| D
    C -->|No| E[Throw InitError]
    D --> F[Print success message]
    E --> G[Exit with error]
    F --> H[Exit 0]
```

#### Default Configuration

The generated configuration includes:

- **version**: 1
- **ordering.members**: Default member order (typealias → deinitializer)
- **extensions.strategy**: separate
- **extensions.respect_boundaries**: true

#### Error Handling

| Error | Condition | Message |
|-------|-----------|---------|
| `InitError.configAlreadyExists` | File exists without `--force` | "Configuration file already exists at {path}. Use --force to overwrite." |

---

### check

Analyzes Swift files and reports which types need member reordering.

**File**: `CheckCommand.swift`

#### Arguments

| Argument | Type | Required | Description |
|----------|------|----------|-------------|
| `files` | `[String]` | Yes | Swift source files to analyze |

#### Options

| Option | Short | Type | Default | Description |
|--------|-------|------|---------|-------------|
| `--config` | `-c` | String? | nil | Path to configuration file |
| `--quiet` | `-q` | Flag | false | Only show files that need reordering |

#### Behavior

```mermaid
flowchart TD
    A[Start] --> B[Load configuration]
    B --> C[Create PipelineCoordinator]
    C --> D[Process files in parallel]
    D --> E[Aggregate results]
    E --> F{Quiet mode?}
    F -->|No| G[Print detailed report per file]
    F -->|Yes| H[Skip detailed output]
    G --> I[Print summary]
    H --> I
    I --> J{Files need reorder?}
    J -->|No| K[Exit 0]
    J -->|Yes| L[Exit 1]
```

#### Output Modes

**Normal mode** (default):
- Prints detailed report for each file showing types and their members
- Shows which members are out of order
- Prints summary with total counts

**Quiet mode** (`--quiet`):
- Only prints paths of files needing reorder
- Prints summary

#### Summary Messages

| Condition | Message |
|-----------|---------|
| All ordered | `✓ All {n} types in {m} files are correctly ordered` |
| Needs reorder | `✗ {n} types in {m} files need reordering` |

---

### fix

Applies member reordering to Swift files.

**File**: `FixCommand.swift`

#### Arguments

| Argument | Type | Required | Description |
|----------|------|----------|-------------|
| `files` | `[String]` | Yes | Swift source files to fix |

#### Options

| Option | Short | Type | Default | Description |
|--------|-------|------|---------|-------------|
| `--config` | `-c` | String? | nil | Path to configuration file |
| `--dry-run` | - | Flag | false | Show changes without modifying files |
| `--quiet` | `-q` | Flag | false | Only show summary |

#### Behavior

```mermaid
flowchart TD
    A[Start] --> B[Load configuration]
    B --> C[Create PipelineCoordinator]
    C --> D[Process files in parallel]
    D --> E{Dry run?}
    E -->|No| F[Write modified files to disk]
    E -->|Yes| G[Skip file writing]
    F --> H[Report modified files]
    G --> H
    H --> I[Print summary]
    I --> J{Dry run AND files modified?}
    J -->|Yes| K[Exit 1]
    J -->|No| L[Exit 0]
```

#### Output Modes

**Normal mode**:
- Prints each modified file path
- Prefix: `Reordered: {path}` or `Would reorder: {path}` (dry-run)

**Quiet mode** (`--quiet`):
- Only prints summary

#### Dry Run Mode

When `--dry-run` is enabled:
- Files are processed but not written to disk
- Output shows what would change
- Exits with code 1 if any files would be modified (useful for CI)

#### Summary Messages

| Condition | Message |
|-----------|---------|
| All ordered | `✓ All {n} files already correctly ordered` |
| Modified (normal) | `✓ {n} files reordered` |
| Would modify (dry-run) | `⚠ {n} files would be modified` |

## Exit Codes

| Code | Command | Condition |
|------|---------|-----------|
| 0 | `init` | Configuration created successfully |
| 0 | `check` | All files correctly ordered |
| 0 | `fix` | Files reordered successfully (or none needed) |
| 1 | `init` | Configuration file exists (without `--force`) |
| 1 | `check` | One or more files need reordering |
| 1 | `fix --dry-run` | One or more files would be modified |

The exit code behavior enables CI/CD integration:

```bash
# Fail CI if files need reordering
swift-marshal check Sources/**/*.swift

# Fail CI if fix would change anything (enforce pre-commit)
swift-marshal fix --dry-run Sources/**/*.swift
```

## Configuration Loading

Both `check` and `fix` commands use `ConfigurationService` to load configuration:

```mermaid
flowchart TD
    A[Command receives --config option] --> B{--config provided?}
    B -->|Yes| C[Load from specified path]
    B -->|No| D[Search for .swift-marshal.yaml]
    C --> E{File exists?}
    D --> F{File found?}
    E -->|Yes| G[Parse YAML]
    E -->|No| H[Throw error]
    F -->|Yes| G
    F -->|No| I[Use default configuration]
    G --> J[Validate and map to Configuration]
    I --> J
    J --> K[Return Configuration]
```

### Search Paths

When no `--config` is specified, the service searches for `.swift-marshal.yaml` in:

1. Current working directory
2. Parent directories (up to root)

If no configuration file is found, default configuration is used.
