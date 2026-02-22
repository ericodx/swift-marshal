# Swift Marshal (Entry Point)

**Source**: `Sources/SwiftMarshal/SwiftMarshal.swift`

The root command that serves as the CLI entry point.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct SwiftMarshal` |
| **Protocol** | `AsyncParsableCommand` |
| **Attribute** | `@main` (application entry point) |

## Configuration

| Property | Value |
|----------|-------|
| `commandName` | `"swift-marshal"` |
| `abstract` | Short description for help |
| `discussion` | Extended help with examples |
| `version` | `Version.current` (see [Version](Version.md)) |
| `subcommands` | Array of command types |

## Responsibilities

- Defines the CLI name and version
- Registers all subcommands
- Provides root-level help text
- Delegates execution to subcommands

## Notes

- Uses `AsyncParsableCommand` to support async subcommands
- Does not implement `run()` - only serves as command container
