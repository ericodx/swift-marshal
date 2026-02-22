struct TypeReorderResult: Sendable {

    // MARK: - Properties

    let name: String
    let kind: TypeKind
    let line: Int
    let originalMembers: [MemberDeclaration]
    let reorderedMembers: [MemberDeclaration]

    // MARK: - Computed Properties

    var needsReordering: Bool {
        originalMembers.map(\.kind) != reorderedMembers.map(\.kind)
    }
}
