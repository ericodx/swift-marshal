# MemberOutputBuilder

**Source**: `Sources/SwiftMarshal/Core/Visitors/Builders/MemberOutputBuilder.swift`

Protocol for building member output from discovery info.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `protocol MemberOutputBuilder` |
| **Protocols** | `Sendable` |

## Associated Types

| Type | Constraint | Description |
|------|------------|-------------|
| `Output` | `Sendable` | The type this builder produces |

## Required Methods

| Method | Parameters | Returns |
|--------|------------|---------|
| `build(from:using:)` | `MemberDiscoveryInfo`, `SourceLocationConverter` | `Output` |

## Implementations

| Builder | Output Type |
|---------|-------------|
| `MemberDeclarationBuilder` | `MemberDeclaration` |
| `SyntaxMemberDeclarationBuilder` | `SyntaxMemberDeclaration` |

## Related

- [MemberDiscoveryInfo](../../Models/MemberDiscoveryInfo.md) - Input type
- [UnifiedMemberDiscoveryVisitor](../UnifiedMemberDiscoveryVisitor.md) - Uses this protocol
