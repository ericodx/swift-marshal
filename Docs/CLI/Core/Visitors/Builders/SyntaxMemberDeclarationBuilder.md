# SyntaxMemberDeclarationBuilder

**Source**: `Sources/SwiftMarshal/Core/Visitors/Builders/SyntaxMemberDeclarationBuilder.swift`

Builds syntax-aware `SyntaxMemberDeclaration` from discovery info.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct SyntaxMemberDeclarationBuilder` |
| **Protocols** | `MemberOutputBuilder` |

## Output Type

`SyntaxMemberDeclaration`

## Build Logic

Converts `MemberDiscoveryInfo` to `SyntaxMemberDeclaration`:
- Creates inner `MemberDeclaration` with line number
- Preserves `MemberBlockItemSyntax` reference
- Wraps both in `SyntaxMemberDeclaration`

## Usage

Used by `SyntaxTypeDeclarationBuilder` for fix operations where syntax nodes are needed for rewriting.

## Related

- [SyntaxMemberDeclaration](../../Models/SyntaxMemberDeclaration.md) - Output type
- [SyntaxTypeDeclarationBuilder](SyntaxTypeDeclarationBuilder.md) - Uses this builder
