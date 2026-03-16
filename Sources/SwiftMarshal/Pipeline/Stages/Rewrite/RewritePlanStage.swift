struct RewritePlanStage: Stage {

    // MARK: - Initialization

    init(engine: ReorderEngine) {
        self.engine = engine
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
        var memberByName: [String: [(index: Int, member: SyntaxMemberDeclaration)]] = [:]
        for (index, member) in originalMembers.enumerated() {
            memberByName[member.declaration.name, default: []].append((index, member))
        }

        var usedIndices = Set<Int>()
        return reorderedDeclarations.compactMap { decl in
            guard let candidates = memberByName[decl.name] else { return nil }
            guard let match = candidates.first(where: { !usedIndices.contains($0.index) }) else { return nil }
            usedIndices.insert(match.index)
            return IndexedSyntaxMember(member: match.member, originalIndex: match.index)
        }
    }
}
