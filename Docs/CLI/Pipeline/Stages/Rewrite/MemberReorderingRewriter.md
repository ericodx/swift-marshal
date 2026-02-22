# MemberReorderingRewriter

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Rewrite/MemberReorderingRewriter.swift`

Syntax rewriter that reorders members within type declarations.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `final class MemberReorderingRewriter` |
| **Inherits** | `SyntaxRewriter` |
| **Protocols** | `@unchecked Sendable` |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `plansByLocation` | `[TypeLocation: TypeRewritePlan]` | Plans indexed by location |

## Initializer

| Parameter | Type | Description |
|-----------|------|-------------|
| `plans` | `[TypeRewritePlan]` | Rewrite plans for types |

Filters plans to only those with `needsRewriting == true`.

## Overridden Methods

| Method | Node Type | Description |
|--------|-----------|-------------|
| `visit(_:)` | `StructDeclSyntax` | Reorder struct members |
| `visit(_:)` | `ClassDeclSyntax` | Reorder class members |
| `visit(_:)` | `EnumDeclSyntax` | Reorder enum members |
| `visit(_:)` | `ActorDeclSyntax` | Reorder actor members |
| `visit(_:)` | `ProtocolDeclSyntax` | Reorder protocol members |

## Private Methods

| Method | Description |
|--------|-------------|
| `findPlan(for:memberBlock:)` | Find matching plan for type |
| `membersMatchByID(memberBlock:plan:)` | Match by syntax node IDs |
| `membersMatchByCount(memberBlock:plan:)` | Fallback match by count |
| `reorderMemberBlock(_:using:)` | Apply reordering to member block |
| `inferLeadingTriviaFromItems(_:trackedIndices:)` | Get trivia for moved first member |

## Plan Matching Strategy

1. **By ID**: Match member syntax node IDs (primary)
2. **By count**: Fallback when IDs don't match

## Trivia Preservation

| Scenario | Handling |
|----------|----------|
| First member stays first | Keep original trivia |
| New first member | Transfer original first's trivia |
| Original first moves | Normalize to second member's trivia |
| Other members | Keep original trivia |

## Design Decisions

- **@unchecked Sendable**: SyntaxRewriter is not Sendable by default
- **Location-based lookup**: Fast plan retrieval by type name and line
- **ID matching first**: Most reliable way to match syntax nodes
- **Trivia normalization**: Prevents formatting issues at boundaries

## Related

- [ApplyRewriteStage](ApplyRewriteStage.md) - Uses this rewriter
- [TypeRewritePlan](TypeRewritePlan.md) - Plan model
- [TypeLocation](TypeLocation.md) - Lookup key
