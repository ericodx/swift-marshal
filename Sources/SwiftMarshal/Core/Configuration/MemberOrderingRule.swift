enum MemberOrderingRule: Equatable, Sendable {

    // MARK: - Cases

    case simple(MemberKind)
    case property(annotated: Bool?, visibility: Visibility?)
    case method(kind: MethodKind?, visibility: Visibility?, annotated: Bool?)

    // MARK: - Public Methods

    func matches(_ member: MemberDeclaration) -> Bool {
        switch self {
        case .simple(let kind):
            return member.kind == kind
        case .property(let annotated, let visibility):
            return matchesProperty(member, annotated: annotated, visibility: visibility)
        case .method(let kind, let visibility, let annotated):
            return matchesMethod(member, kind: kind, visibility: visibility, annotated: annotated)
        }
    }

    // MARK: - Private Methods

    private func matchesProperty(
        _ member: MemberDeclaration,
        annotated: Bool?,
        visibility: Visibility?
    ) -> Bool {
        guard member.kind == .instanceProperty || member.kind == .typeProperty else {
            return false
        }
        if let annotated = annotated, member.isAnnotated != annotated {
            return false
        }
        if let visibility = visibility, member.visibility != visibility {
            return false
        }
        return true
    }

    private func matchesMethod(
        _ member: MemberDeclaration,
        kind: MethodKind?,
        visibility: Visibility?,
        annotated: Bool?
    ) -> Bool {
        let isMethodKind = matchesMethodKind(member.kind, expected: kind)
        guard isMethodKind else { return false }

        if let annotated = annotated, member.isAnnotated != annotated {
            return false
        }
        if let visibility = visibility, member.visibility != visibility {
            return false
        }
        return true
    }

    private func matchesMethodKind(_ memberKind: MemberKind, expected: MethodKind?) -> Bool {
        switch expected {
        case .staticMethod:
            return memberKind == .typeMethod
        case .instance:
            return memberKind == .instanceMethod
        case nil:
            return memberKind == .typeMethod || memberKind == .instanceMethod
        }
    }
}
