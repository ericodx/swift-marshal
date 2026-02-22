import SwiftSyntax

struct MemberDeclarationBuilder: MemberOutputBuilder {

    // MARK: - MemberOutputBuilder

    func build(from info: MemberDiscoveryInfo, using converter: SourceLocationConverter) -> MemberDeclaration {
        let location = converter.location(for: info.position)
        return MemberDeclaration(
            name: info.name,
            kind: info.kind,
            line: location.line,
            visibility: info.visibility,
            isAnnotated: info.isAnnotated
        )
    }
}
