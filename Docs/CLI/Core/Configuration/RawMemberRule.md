# RawMemberRule

**Source**: `Sources/SwiftMarshal/Core/Configuration/RawMemberRule.swift`

Unvalidated member rule parsed from YAML.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `enum RawMemberRule` |
| **Protocols** | `Equatable`, `Sendable` |

## Cases

| Case | Associated Values | Description |
|------|-------------------|-------------|
| `simple` | `String` | Simple kind identifier |
| `property` | `annotated: Bool?`, `visibility: String?` | Property with filters |
| `method` | `kind: String?`, `visibility: String?`, `annotated: Bool?` | Method with filters |

## Purpose

Represents member rules before validation. Uses raw strings instead of enums to capture exactly what was in the YAML file.

## Example Mappings

| YAML | RawMemberRule |
|------|---------------|
| `initializer` | `.simple("initializer")` |
| `property: { visibility: private }` | `.property(annotated: nil, visibility: "private")` |
| `method: { kind: static }` | `.method(kind: "static", visibility: nil, annotated: nil)` |

## Related

- [ConfigurationLoader](ConfigurationLoader.md) - Produces this type
- [ConfigurationMapper](ConfigurationMapper.md) - Maps to `MemberOrderingRule`
- [MemberOrderingRule](MemberOrderingRule.md) - Validated version
