struct CheckResult: Sendable {
    let path: String
    let results: [TypeReorderResult]
    let needsReorder: Bool
    let reportText: String
}
