# ReorderEngine

**Source**: `Sources/SwiftMarshal/Core/Reordering/ReorderEngine.swift`

Sorts members according to configured ordering rules.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ReorderEngine` |

## Dependencies

| Dependency | Description |
|------------|-------------|
| `Configuration` | Provides ordering rules |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `rules` | `[MemberOrderingRule]` | Extracted from configuration |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `reorder(_:)` | `[MemberDeclaration]` | `[MemberDeclaration]` | Sort members by rules |

## Private Methods

| Method | Description |
|--------|-------------|
| `ruleIndex(for:)` | Find first matching rule index |

## Algorithm

```text
For each member:
  1. Iterate through rules in order
  2. Find first rule that matches the member
  3. Assign that rule's index as sort key
  4. If no rule matches, assign index = rules.count (sort last)

Sort members by their assigned indices (stable sort)
```

## Stable Sorting

Members matching the same rule maintain their original relative order. This preserves intentional groupings within a category.

## Unmatched Members

Members that don't match any rule are placed at the end, maintaining their relative order among themselves.

## Example

Given rules: `[initializer, instanceProperty, instanceMethod]`

| Member | Matching Rule | Index |
|--------|---------------|-------|
| `init()` | `initializer` | 0 |
| `var name` | `instanceProperty` | 1 |
| `func run()` | `instanceMethod` | 2 |
| `typealias X` | (none) | 3 |

## Related

- [MemberOrderingRule](../Configuration/MemberOrderingRule.md) - Rule matching logic
- [Configuration](../Configuration/Configuration.md) - Source of rules
