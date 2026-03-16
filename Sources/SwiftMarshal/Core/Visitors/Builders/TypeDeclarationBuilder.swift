import SwiftSyntax

struct TypeDeclarationBuilder: TypeOutputBuilder {

    // MARK: - Properties

    let memberBuilder = MemberDeclarationBuilder()

    // MARK: - TypeOutputBuilder

    func build(
        from info: TypeDiscoveryInfo<MemberDeclaration>,
        using converter: SourceLocationConverter
    ) -> TypeDeclaration {
        TypeDeclaration(
            name: info.name,
            kind: info.kind,
            line: converter.location(for: info.position).line,
            members: info.members
        )
    }
}
