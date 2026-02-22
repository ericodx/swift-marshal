import SwiftSyntax

final class UnifiedTypeDiscoveryVisitor<Builder: TypeOutputBuilder>: SyntaxVisitor {

    init(sourceLocationConverter: SourceLocationConverter, builder: Builder) {
        self.sourceLocationConverter = sourceLocationConverter
        self.builder = builder
        super.init(viewMode: .sourceAccurate)
    }

    private(set) var declarations: [Builder.Output] = []
    private let sourceLocationConverter: SourceLocationConverter
    private let builder: Builder

    // MARK: - Type Declarations

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = discoverMembers(in: node.memberBlock)
        let position = node.positionAfterSkippingLeadingTrivia
        record(
            name: node.name.text,
            kind: .classType,
            position: position,
            members: members,
            memberBlock: node.memberBlock
        )
        return .visitChildren
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = discoverMembers(in: node.memberBlock)
        let position = node.positionAfterSkippingLeadingTrivia
        record(
            name: node.name.text,
            kind: .structType,
            position: position,
            members: members,
            memberBlock: node.memberBlock
        )
        return .visitChildren
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = discoverMembers(in: node.memberBlock)
        let position = node.positionAfterSkippingLeadingTrivia
        record(
            name: node.name.text,
            kind: .enumType,
            position: position,
            members: members,
            memberBlock: node.memberBlock
        )
        return .visitChildren
    }

    override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = discoverMembers(in: node.memberBlock)
        let position = node.positionAfterSkippingLeadingTrivia
        record(
            name: node.name.text,
            kind: .actorType,
            position: position,
            members: members,
            memberBlock: node.memberBlock
        )
        return .visitChildren
    }

    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = discoverMembers(in: node.memberBlock)
        let position = node.positionAfterSkippingLeadingTrivia
        record(
            name: node.name.text,
            kind: .protocolType,
            position: position,
            members: members,
            memberBlock: node.memberBlock
        )
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

extension UnifiedTypeDiscoveryVisitor where Builder == TypeDeclarationBuilder {
    static func forDeclarations(
        converter: SourceLocationConverter
    ) -> UnifiedTypeDiscoveryVisitor<TypeDeclarationBuilder> {
        UnifiedTypeDiscoveryVisitor(
            sourceLocationConverter: converter,
            builder: TypeDeclarationBuilder()
        )
    }
}

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
