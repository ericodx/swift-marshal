struct MemberDeclaration: Sendable {

    // MARK: - Initialization

    init(
        name: String,
        kind: MemberKind,
        line: Int,
        visibility: Visibility = .internalAccess,
        isAnnotated: Bool = false
    ) {
        self.name = name
        self.kind = kind
        self.line = line
        self.visibility = visibility
        self.isAnnotated = isAnnotated
    }

    // MARK: - Properties

    let name: String
    let kind: MemberKind
    let line: Int
    let visibility: Visibility
    let isAnnotated: Bool
}
