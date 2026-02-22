struct ConfigurationMapper {

    // MARK: - Public Methods

    func map(_ raw: RawConfiguration) -> Configuration {
        Configuration(
            version: raw.version,
            memberOrderingRules: mapMemberRules(raw.memberRules),
            extensionsStrategy: mapExtensionsStrategy(raw.extensionsStrategy),
            respectBoundaries: raw.respectBoundaries ?? true
        )
    }

    // MARK: - Private Methods

    private func mapMemberRules(_ rawRules: [RawMemberRule]) -> [MemberOrderingRule] {
        let mappedRules = rawRules.compactMap { mapMemberRule($0) }
        return mappedRules.isEmpty ? defaultRules() : mappedRules
    }

    private func mapMemberRule(_ raw: RawMemberRule) -> MemberOrderingRule? {
        switch raw {
        case .simple(let kindString):
            guard let kind = MemberKind(rawValue: kindString) else { return nil }
            return .simple(kind)

        case .property(let annotated, let visibilityString):
            let visibility = visibilityString.flatMap { Visibility(rawValue: $0) }
            return .property(annotated: annotated, visibility: visibility)

        case .method(let kindString, let visibilityString, let annotated):
            let kind = kindString.flatMap { MethodKind(rawValue: $0) }
            let visibility = visibilityString.flatMap { Visibility(rawValue: $0) }
            return .method(kind: kind, visibility: visibility, annotated: annotated)
        }
    }

    private func mapExtensionsStrategy(_ rawStrategy: String?) -> ExtensionsStrategy {
        guard let rawStrategy = rawStrategy else { return .separate }
        return ExtensionsStrategy(rawValue: rawStrategy) ?? .separate
    }

    private func defaultRules() -> [MemberOrderingRule] {
        MemberKind.allCases.map { .simple($0) }
    }
}
