enum RawMemberRule: Equatable, Sendable {
    case simple(String)
    case property(annotated: Bool?, visibility: String?)
    case method(kind: String?, visibility: String?, annotated: Bool?)
}
