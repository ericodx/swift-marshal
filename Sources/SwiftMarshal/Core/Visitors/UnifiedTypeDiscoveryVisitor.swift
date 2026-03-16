import SwiftSyntax

final class UnifiedTypeDiscoveryVisitor<Builder: TypeOutputBuilder>: UnifiedVisitorBase<Builder> {

    private(set) var declarations: [Builder.Output] = []

    // MARK: - Type Declarations

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        visitTypeDecl(
            name: node.name.text,
            kind: .classType,
            memberBlock: node.memberBlock,
            position: node.positionAfterSkippingLeadingTrivia
        )
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        visitTypeDecl(
            name: node.name.text,
            kind: .structType,
            memberBlock: node.memberBlock,
            position: node.positionAfterSkippingLeadingTrivia
        )
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        visitTypeDecl(
            name: node.name.text,
            kind: .enumType,
            memberBlock: node.memberBlock,
            position: node.positionAfterSkippingLeadingTrivia
        )
    }

    override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
        visitTypeDecl(
            name: node.name.text,
            kind: .actorType,
            memberBlock: node.memberBlock,
            position: node.positionAfterSkippingLeadingTrivia
        )
    }

    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        visitTypeDecl(
            name: node.name.text,
            kind: .protocolType,
            memberBlock: node.memberBlock,
            position: node.positionAfterSkippingLeadingTrivia
        )
    }

    private func visitTypeDecl(
        name: String,
        kind: TypeKind,
        memberBlock: MemberBlockSyntax,
        position: AbsolutePosition
    ) -> SyntaxVisitorContinueKind {
        let members = discoverMembers(in: memberBlock)
        record(name: name, kind: kind, position: position, members: members, memberBlock: memberBlock)
        return .visitChildren
    }

    // MARK: - Private Helpers

    private func discoverMembers(in memberBlock: MemberBlockSyntax) -> [Builder.MemberBuilder.Output] {
        let visitor = UnifiedMemberDiscoveryVisitor(
            sourceLocationConverter: sourceLocationConverter,
            builder: builder.memberBuilder
        )
        for item in memberBlock.members {
            visitor.process(item)
        }
        return visitor.members
    }

    private func record(
        name: String,
        kind: TypeKind,
        position: AbsolutePosition,
        members: [Builder.MemberBuilder.Output],
        memberBlock: MemberBlockSyntax
    ) {
        let info = TypeDiscoveryInfo(
            name: name,
            kind: kind,
            position: position,
            members: members,
            memberBlock: memberBlock
        )
        let output = builder.build(from: info, using: sourceLocationConverter)
        declarations.append(output)
    }
}

// MARK: - Convenience Factory Methods

extension UnifiedTypeDiscoveryVisitor where Builder == SyntaxTypeDeclarationBuilder {
    static func forSyntaxDeclarations(
        converter: SourceLocationConverter
    ) -> UnifiedTypeDiscoveryVisitor<SyntaxTypeDeclarationBuilder> {
        UnifiedTypeDiscoveryVisitor(
            sourceLocationConverter: converter,
            builder: SyntaxTypeDeclarationBuilder()
        )
    }
}
