# TypeReorderResult

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Reorder/TypeReorderResult.swift`

Result of reorder analysis for a single type.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct TypeReorderResult` |
| **Protocols** | `Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `name` | `String` | Type name |
| `kind` | `TypeKind` | Type kind (struct, class, etc.) |
| `line` | `Int` | Declaration line number |
| `originalMembers` | `[MemberDeclaration]` | Members in original order |
| `reorderedMembers` | `[MemberDeclaration]` | Members in correct order |

## Computed Properties

| Property | Type | Description |
|----------|------|-------------|
| `needsReordering` | `Bool` | Whether order differs |

## needsReordering Logic

Compares member kinds (not names) between original and reordered:
- If kind sequences differ, reordering is needed
- Uses `map(\.kind)` for comparison

## Usage

Used by:
- `PipelineCoordinator.CheckResult` to determine file needs fix
- `ReorderReportStage` to generate detailed report

## Related

- [ReorderStage](ReorderStage.md) - Creates these results
- [MemberDeclaration](../../../Core/Models/MemberDeclaration.md) - Member model
- [TypeKind](../../../Core/Models/TypeKind.md) - Type kind enum
