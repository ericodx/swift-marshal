struct TypeReorderResult: Sendable {

    // MARK: - Initialization

    init(
        name: String,
        kind: TypeKind,
        line: Int,
        originalMembers: [MemberDeclaration],
        reorderedMembers: [MemberDeclaration]
    ) {
        self.name = name
        self.kind = kind
        self.line = line
        self.originalMembers = originalMembers
        self.reorderedMembers = reorderedMembers
    }

    init(from plan: TypeRewritePlan) {
        self.name = plan.typeName
        self.kind = plan.kind
        self.line = plan.line
        self.originalMembers = plan.originalMembers.map(\.declaration)
        self.reorderedMembers = plan.reorderedMembers.map(\.member.declaration)
    }

    // MARK: - Properties

    let name: String
    let kind: TypeKind
    let line: Int
    let originalMembers: [MemberDeclaration]
    let reorderedMembers: [MemberDeclaration]

    // MARK: - Computed Properties

    var needsReordering: Bool {
        originalMembers.map(\.line) != reorderedMembers.map(\.line)
    }
}
