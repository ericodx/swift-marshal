# SyntaxTypeDeclarationBuilder

**Source**: `Sources/SwiftMarshal/Core/Visitors/Builders/SyntaxTypeDeclarationBuilder.swift`

Builds syntax-aware `SyntaxTypeDeclaration` from discovery info.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct SyntaxTypeDeclarationBuilder` |
| **Protocols** | `TypeOutputBuilder` |

## Associated Types

| Type | Value |
|------|-------|
| `MemberBuilder` | `SyntaxMemberDeclarationBuilder` |
| `Output` | `SyntaxTypeDeclaration` |

## Output Type

`SyntaxTypeDeclaration`

## Build Logic

Converts `TypeDiscoveryInfo` to `SyntaxTypeDeclaration`:
- Calculates line number from position using converter
- Copies name, kind
- Includes already-built syntax-aware members
- Preserves `MemberBlockSyntax` reference

## Usage

Used in fix operations via `UnifiedTypeDiscoveryVisitor.forSyntaxDeclarations(converter:)`.

## Related

- [SyntaxTypeDeclaration](../../Models/SyntaxTypeDeclaration.md) - Output type
- [SyntaxMemberDeclarationBuilder](SyntaxMemberDeclarationBuilder.md) - Member builder
