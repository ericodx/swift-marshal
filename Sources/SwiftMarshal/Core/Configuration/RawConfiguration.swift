struct RawConfiguration: Equatable, Sendable {
    let version: Int
    let memberRules: [RawMemberRule]
    let extensionsStrategy: String?
    let respectBoundaries: Bool?
}
