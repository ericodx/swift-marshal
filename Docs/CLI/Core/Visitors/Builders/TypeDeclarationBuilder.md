# TypeDeclarationBuilder

**Source**: `Sources/SwiftMarshal/Core/Visitors/Builders/TypeDeclarationBuilder.swift`

Builds lightweight `TypeDeclaration` from discovery info.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct TypeDeclarationBuilder` |
| **Protocols** | `TypeOutputBuilder` |

## Associated Types

| Type | Value |
|------|-------|
| `MemberBuilder` | `MemberDeclarationBuilder` |
| `Output` | `TypeDeclaration` |

## Output Type

`TypeDeclaration`

## Build Logic

Converts `TypeDiscoveryInfo` to `TypeDeclaration`:
- Calculates line number from position using converter
- Copies name, kind
- Includes already-built members
- Discards memberBlock syntax node

## Usage

Used in check operations via `UnifiedTypeDiscoveryVisitor.forDeclarations(converter:)`.

## Related

- [TypeDeclaration](../../Models/TypeDeclaration.md) - Output type
- [MemberDeclarationBuilder](MemberDeclarationBuilder.md) - Member builder
