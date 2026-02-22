# TypeLocation

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Rewrite/TypeLocation.swift`

Hashable key for identifying type declarations.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct TypeLocation` |
| **Protocols** | `Hashable`, `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `name` | `String` | Type name |
| `line` | `Int` | Declaration line number |

## Purpose

Used as dictionary key in `MemberReorderingRewriter.plansByLocation` for fast plan lookup during syntax tree traversal.

## Why Both Name and Line

- **Name only**: Would fail for multiple types with same name
- **Line only**: Would fail if types span same line
- **Both**: Uniquely identifies type in file

## Related

- [MemberReorderingRewriter](MemberReorderingRewriter.md) - Uses as lookup key
- [TypeRewritePlan](TypeRewritePlan.md) - Has matching name and line
