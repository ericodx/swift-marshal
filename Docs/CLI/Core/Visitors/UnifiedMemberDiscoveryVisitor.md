# UnifiedMemberDiscoveryVisitor

**Source**: `Sources/SwiftMarshal/Core/Visitors/UnifiedMemberDiscoveryVisitor.swift`

Discovers members within a type's member block.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `final class UnifiedMemberDiscoveryVisitor<Builder>` |
| **Superclass** | `SyntaxVisitor` |
| **Protocols** | `@unchecked Sendable` |
| **Generic** | `Builder: MemberOutputBuilder` |

## Dependencies

| Dependency | Description |
|------------|-------------|
| `SourceLocationConverter` | Converts positions to line numbers |
| `Builder` | Produces output from discovery info |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `members` | `[Builder.Output]` | Discovered members |
| `currentItem` | `MemberBlockItemSyntax?` | Current member block item |
| `depth` | `Int` | Nesting depth for nested types |

## Public Methods

| Method | Description |
|--------|-------------|
| `process(_:)` | Process a single member block item |

## Visitor Methods

| Method | Node Type | Member Kind |
|--------|-----------|-------------|
| `visit(_:)` | `VariableDeclSyntax` | `typeProperty` or `instanceProperty` |
| `visit(_:)` | `InitializerDeclSyntax` | `initializer` |
| `visit(_:)` | `DeinitializerDeclSyntax` | `deinitializer` |
| `visit(_:)` | `FunctionDeclSyntax` | `typeMethod` or `instanceMethod` |
| `visit(_:)` | `SubscriptDeclSyntax` | `subscript` |
| `visit(_:)` | `TypeAliasDeclSyntax` | `typealias` |
| `visit(_:)` | `AssociatedTypeDeclSyntax` | `associatedtype` |
| `visit(_:)` | `ClassDeclSyntax` | `subtype` |
| `visit(_:)` | `StructDeclSyntax` | `subtype` |
| `visit(_:)` | `EnumDeclSyntax` | `subtype` |
| `visit(_:)` | `ActorDeclSyntax` | `subtype` |
| `visit(_:)` | `ProtocolDeclSyntax` | `subtype` |

## Depth Tracking

Nested type visitors increment `depth` on entry and decrement on exit. Members are only recorded at `depth == 0` to avoid capturing nested type members.

## Visibility Extraction

The `extractVisibility(from:)` method examines modifier keywords to determine access level, defaulting to `.internal`.

## Multiple Bindings

Variable declarations with multiple bindings (e.g., `var a, b: Int`) produce multiple member records.

## Related

- [UnifiedTypeDiscoveryVisitor](UnifiedTypeDiscoveryVisitor.md) - Creates this visitor
- [MemberOutputBuilder](Builders/MemberOutputBuilder.md) - Builder protocol
- [MemberDiscoveryInfo](../Models/MemberDiscoveryInfo.md) - Intermediate data
