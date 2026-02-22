struct TypeRewritePlan: Sendable {

    // MARK: - Properties

    let typeName: String
    let kind: TypeKind
    let line: Int
    let originalMembers: [SyntaxMemberDeclaration]
    let reorderedMembers: [IndexedSyntaxMember]

    // MARK: - Computed Properties

    var needsRewriting: Bool {
        originalMembers.map(\.declaration.kind) != reorderedMembers.map(\.member.declaration.kind)
    }
}
