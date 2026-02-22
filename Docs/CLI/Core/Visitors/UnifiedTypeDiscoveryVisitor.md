# UnifiedTypeDiscoveryVisitor

**Source**: `Sources/SwiftMarshal/Core/Visitors/UnifiedTypeDiscoveryVisitor.swift`

Discovers type declarations in SwiftSyntax AST.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `final class UnifiedTypeDiscoveryVisitor<Builder>` |
| **Superclass** | `SyntaxVisitor` |
| **Protocols** | `@unchecked Sendable` |
| **Generic** | `Builder: TypeOutputBuilder` |

## Dependencies

| Dependency | Description |
|------------|-------------|
| `SourceLocationConverter` | Converts positions to line numbers |
| `Builder` | Produces output from discovery info |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `declarations` | `[Builder.Output]` | Discovered type declarations |

## Visitor Methods

| Method | Node Type | Description |
|--------|-----------|-------------|
| `visit(_:)` | `ClassDeclSyntax` | Discover class |
| `visit(_:)` | `StructDeclSyntax` | Discover struct |
| `visit(_:)` | `EnumDeclSyntax` | Discover enum |
| `visit(_:)` | `ActorDeclSyntax` | Discover actor |
| `visit(_:)` | `ProtocolDeclSyntax` | Discover protocol |

## Private Methods

| Method | Description |
|--------|-------------|
| `discoverMembers(in:)` | Create member visitor and discover members |
| `record(...)` | Build output and append to declarations |

## Traversal Behavior

All visitor methods return `.visitChildren` to discover nested types.

## Factory Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forDeclarations(converter:)` | `UnifiedTypeDiscoveryVisitor<TypeDeclarationBuilder>` | Lightweight output |
| `forSyntaxDeclarations(converter:)` | `UnifiedTypeDiscoveryVisitor<SyntaxTypeDeclarationBuilder>` | Syntax-aware output |

## Related

- [UnifiedMemberDiscoveryVisitor](UnifiedMemberDiscoveryVisitor.md) - Member discovery
- [TypeOutputBuilder](Builders/TypeOutputBuilder.md) - Builder protocol
