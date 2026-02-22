# MemberDeclarationBuilder

**Source**: `Sources/SwiftMarshal/Core/Visitors/Builders/MemberDeclarationBuilder.swift`

Builds lightweight `MemberDeclaration` from discovery info.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct MemberDeclarationBuilder` |
| **Protocols** | `MemberOutputBuilder` |

## Output Type

`MemberDeclaration`

## Build Logic

Converts `MemberDiscoveryInfo` to `MemberDeclaration`:
- Calculates line number from position using converter
- Copies name, kind, visibility, isAnnotated
- Discards syntax node reference

## Usage

Used by `TypeDeclarationBuilder` for check operations where syntax nodes are not needed.

## Related

- [MemberDeclaration](../../Models/MemberDeclaration.md) - Output type
- [TypeDeclarationBuilder](TypeDeclarationBuilder.md) - Uses this builder
