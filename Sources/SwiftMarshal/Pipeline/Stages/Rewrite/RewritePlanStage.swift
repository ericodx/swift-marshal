struct RewritePlanStage: Stage {

    // MARK: - Initialization

    init(configuration: Configuration = .defaultValue) {
        self.engine = ReorderEngine(configuration: configuration)
    }

    // MARK: - Properties

    private let engine: ReorderEngine

    // MARK: - Stage

    func process(_ input: SyntaxClassifyOutput) throws -> RewritePlanOutput {
        let plans = input.declarations.map { typeDecl -> TypeRewritePlan in
            let reorderedDeclarations = engine.reorder(typeDecl.members.map(\.declaration))
            let reorderedMembers = mapToIndexedMembers(
                reorderedDeclarations: reorderedDeclarations,
                originalMembers: typeDecl.members
            )

            return TypeRewritePlan(
                typeName: typeDecl.name,
                kind: typeDecl.kind,
                line: typeDecl.line,
                originalMembers: typeDecl.members,
                reorderedMembers: reorderedMembers
            )
        }

        return RewritePlanOutput(path: input.path, syntax: input.syntax, plans: plans)
    }

    // MARK: - Private Methods

    private func mapToIndexedMembers(
        reorderedDeclarations: [MemberDeclaration],
        originalMembers: [SyntaxMemberDeclaration]
    ) -> [IndexedSyntaxMember] {
        var memberByLine: [Int: (index: Int, member: SyntaxMemberDeclaration)] = [:]
        for (index, member) in originalMembers.enumerated() {
            memberByLine[member.declaration.line] = (index, member)
        }

        return reorderedDeclarations.compactMap { decl in
            memberByLine[decl.line].map { IndexedSyntaxMember(member: $0.member, originalIndex: $0.index) }
        }
    }
}
