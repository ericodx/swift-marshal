import SwiftSyntax

struct MemberDeclarationBuilder: MemberOutputBuilder {

    // MARK: - MemberOutputBuilder

    func build(from info: MemberDiscoveryInfo, using converter: SourceLocationConverter) -> MemberDeclaration {
        MemberDeclaration(
            name: info.name,
            kind: info.kind,
            line: converter.location(for: info.position).line,
            visibility: info.visibility,
            isAnnotated: info.isAnnotated
        )
    }
}
