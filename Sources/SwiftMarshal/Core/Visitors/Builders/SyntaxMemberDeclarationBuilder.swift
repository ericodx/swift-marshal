import SwiftSyntax

struct SyntaxMemberDeclarationBuilder: MemberOutputBuilder {

    // MARK: - MemberOutputBuilder

    func build(from info: MemberDiscoveryInfo, using converter: SourceLocationConverter) -> SyntaxMemberDeclaration {
        let location = converter.location(for: info.position)
        let declaration = MemberDeclaration(
            name: info.name,
            kind: info.kind,
            line: location.line,
            visibility: info.visibility,
            isAnnotated: info.isAnnotated
        )
        return SyntaxMemberDeclaration(declaration: declaration, syntax: info.item)
    }
}
