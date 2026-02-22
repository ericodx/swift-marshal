# TypeOutputBuilder

**Source**: `Sources/SwiftMarshal/Core/Visitors/Builders/TypeOutputBuilder.swift`

Protocol for building type output from discovery info.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `protocol TypeOutputBuilder` |
| **Protocols** | `Sendable` |

## Associated Types

| Type | Constraint | Description |
|------|------------|-------------|
| `MemberBuilder` | `MemberOutputBuilder` | Builder for members |
| `Output` | `Sendable` | The type this builder produces |

## Required Properties

| Property | Type | Description |
|----------|------|-------------|
| `memberBuilder` | `MemberBuilder` | Builder for nested members |

## Required Methods

| Method | Parameters | Returns |
|--------|------------|---------|
| `build(from:using:)` | `TypeDiscoveryInfo<MemberBuilder.Output>`, `SourceLocationConverter` | `Output` |

## Implementations

| Builder | Output Type | Member Builder |
|---------|-------------|----------------|
| `TypeDeclarationBuilder` | `TypeDeclaration` | `MemberDeclarationBuilder` |
| `SyntaxTypeDeclarationBuilder` | `SyntaxTypeDeclaration` | `SyntaxMemberDeclarationBuilder` |

## Related

- [TypeDiscoveryInfo](../../Models/TypeDiscoveryInfo.md) - Input type
- [UnifiedTypeDiscoveryVisitor](../UnifiedTypeDiscoveryVisitor.md) - Uses this protocol
