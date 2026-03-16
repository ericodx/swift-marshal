enum MemberKind: String, Sendable, CaseIterable {
    case typeAlias = "typealias"
    case associatedType = "associatedtype"
    case initializer = "initializer"
    case typeProperty = "type_property"
    case instanceProperty = "instance_property"
    case subtype = "subtype"
    case typeMethod = "type_method"
    case instanceMethod = "instance_method"
    case subscriptMember = "subscript"
    case deinitializer = "deinitializer"
}
