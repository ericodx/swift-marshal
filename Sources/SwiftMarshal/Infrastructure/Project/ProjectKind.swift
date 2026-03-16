enum ProjectKind: Sendable, Equatable {
    case spm(sourcesPath: String)
    case xcode(sourcesPath: String)
    case unknown
}
