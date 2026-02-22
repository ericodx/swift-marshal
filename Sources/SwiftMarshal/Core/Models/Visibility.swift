enum Visibility: String, Sendable, CaseIterable {
    case openAccess = "open"
    case publicAccess = "public"
    case internalAccess = "internal"
    case filePrivateAccess = "fileprivate"
    case privateAccess = "private"
}
