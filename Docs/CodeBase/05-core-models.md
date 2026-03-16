# Core Models

← [Stages](04-stages.md) | Next: [Configuration →](06-configuration.md)

---

## MemberDeclaration

`Core/Models/MemberDeclaration.swift`

The semantic description of a single type member. Drives all reordering decisions.

```swift
struct MemberDeclaration: Sendable {
    let name:        String
    let kind:        MemberKind
    let line:        Int
    let visibility:  Visibility   // default: .internalAccess
    let isAnnotated: Bool         // default: false
}
```

| Field | Description |
|---|---|
| `name` | Identifier as written in source |
| `kind` | Declaration category (see `MemberKind`) |
| `line` | Source line number |
| `visibility` | Access modifier (defaults to `internal`) |
| `isAnnotated` | `true` when the member carries a property-wrapper or result-builder annotation |

---

## MemberKind

`Core/Models/MemberKind.swift`

```swift
enum MemberKind: String, Sendable, CaseIterable {
    case typeAlias       = "typealias"
    case associatedType  = "associatedtype"
    case initializer     = "initializer"
    case typeProperty    = "type_property"
    case instanceProperty = "instance_property"
    case subtype         = "subtype"
    case typeMethod      = "type_method"
    case instanceMethod  = "instance_method"
    case subscriptMember = "subscript"
    case deinitializer   = "deinitializer"
}
```

`rawValue` matches the YAML keys used in `.swift-marshal.yaml`. `CaseIterable` is used to build the default ordering rules in `Configuration.defaultValue`.

| Case | Declaration |
|---|---|
| `typeAlias` | `typealias` |
| `associatedType` | `associatedtype` |
| `initializer` | `init` |
| `typeProperty` | `static var` / `class var` |
| `instanceProperty` | `var` / `let` (instance) |
| `subtype` | Nested type declaration |
| `typeMethod` | `static func` / `class func` |
| `instanceMethod` | `func` (instance) |
| `subscriptMember` | `subscript` |
| `deinitializer` | `deinit` |

---

## Visibility

`Core/Models/Visibility.swift`

```swift
enum Visibility: String, Sendable, CaseIterable {
    case openAccess        = "open"
    case publicAccess      = "public"
    case internalAccess    = "internal"
    case filePrivateAccess = "fileprivate"
    case privateAccess     = "private"
}
```

`rawValue` matches YAML visibility strings. Members without an explicit modifier are treated as `.internalAccess`.

---

## TypeKind

`Core/Models/TypeKind.swift`

```swift
enum TypeKind: String, Sendable {
    case classType
    case structType
    case enumType
    case actorType
    case protocolType
}
```

Identifies the Swift declaration keyword of the containing type. Used in reports and plan matching.

---

## SyntaxTypeDeclaration

`Core/Models/SyntaxTypeDeclaration.swift`

Bridges the semantic layer with the SwiftSyntax AST for a complete type declaration.

```swift
struct SyntaxTypeDeclaration: Sendable {
    let name:        String
    let kind:        TypeKind
    let line:        Int
    let members:     [SyntaxMemberDeclaration]
    let memberBlock: MemberBlockSyntax
}
```

| Field | Description |
|---|---|
| `name` | Type name |
| `kind` | Struct, class, enum, actor, or protocol |
| `line` | Declaration line number |
| `members` | All direct members (see `SyntaxMemberDeclaration`) |
| `memberBlock` | Original `MemberBlockSyntax` node retained for rewriting |

---

## SyntaxMemberDeclaration

`Core/Models/SyntaxMemberDeclaration.swift`

Pairs the semantic `MemberDeclaration` with its original `MemberBlockItemSyntax` node.

```swift
struct SyntaxMemberDeclaration: Sendable {
    let declaration: MemberDeclaration
    let syntax:      MemberBlockItemSyntax
}
```

The `declaration` side drives reordering decisions; `syntax` drives AST mutation in `MemberReorderingRewriter`.

---

## TypeReorderResult

`Pipeline/Stages/Reorder/TypeReorderResult.swift`

The final report model for a single type, consumed by `ReorderReportStage` and `CheckCommand`.

```swift
struct TypeReorderResult: Sendable {
    let name:             String
    let kind:             TypeKind
    let line:             Int
    let originalMembers:  [MemberDeclaration]
    let reorderedMembers: [MemberDeclaration]

    var needsReordering: Bool { get }

    init(name:, kind:, line:, originalMembers:, reorderedMembers:)
    init(from plan: TypeRewritePlan)
}
```

`needsReordering` compares the `line` values of `originalMembers` and `reorderedMembers`. Two members at the same lines in the same order means no change is needed.

`init(from:)` is the single conversion point from pipeline output to report model, used in `PipelineCoordinator.checkSingleFile`.

---

← [Stages](04-stages.md) | Next: [Configuration →](06-configuration.md)
