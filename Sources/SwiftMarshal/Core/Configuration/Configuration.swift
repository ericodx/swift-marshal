struct Configuration: Equatable, Sendable {

    // MARK: - Static Properties

    static let defaultValue = Configuration(
        version: 1,
        memberOrderingRules: MemberKind.allCases.map { .simple($0) },
        extensionsStrategy: .separate,
        respectBoundaries: true,
        paths: []
    )

    // MARK: - Properties

    let version: Int
    let memberOrderingRules: [MemberOrderingRule]
    let extensionsStrategy: ExtensionsStrategy
    let respectBoundaries: Bool
    let paths: [String]
}
