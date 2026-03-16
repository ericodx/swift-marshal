struct ReorderEngine {

    // MARK: - Initialization

    init(configuration: Configuration) {
        self.rules = configuration.memberOrderingRules
    }

    // MARK: - Properties

    private let rules: [MemberOrderingRule]

    // MARK: - Public Methods

    func reorder(_ members: [MemberDeclaration]) -> [MemberDeclaration] {
        members.sorted { lhs, rhs in
            let lhsIndex = ruleIndex(for: lhs)
            let rhsIndex = ruleIndex(for: rhs)
            return lhsIndex < rhsIndex
        }
    }

    // MARK: - Private Methods

    private func ruleIndex(for member: MemberDeclaration) -> Int {
        for (index, rule) in rules.enumerated() where rule.matches(member) {
            return index
        }
        return rules.count
    }
}
