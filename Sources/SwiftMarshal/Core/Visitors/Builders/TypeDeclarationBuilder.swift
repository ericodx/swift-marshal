import SwiftSyntax

struct TypeDeclarationBuilder: TypeOutputBuilder {

    // MARK: - Properties

    let memberBuilder = MemberDeclarationBuilder()

    // MARK: - TypeOutputBuilder

    func build(
        from info: TypeDiscoveryInfo<MemberDeclaration>,
        using converter: SourceLocationConverter
    ) -> TypeDeclaration {
        let location = converter.location(for: info.position)
        return TypeDeclaration(
            name: info.name,
            kind: info.kind,
            line: location.line,
            members: info.members
        )
    }
}
