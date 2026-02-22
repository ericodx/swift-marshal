import SwiftSyntax

final class UnifiedMemberDiscoveryVisitor<Builder: MemberOutputBuilder>: SyntaxVisitor {

    init(sourceLocationConverter: SourceLocationConverter, builder: Builder) {
        self.sourceLocationConverter = sourceLocationConverter
        self.builder = builder
        super.init(viewMode: .sourceAccurate)
    }

    private(set) var members: [Builder.Output] = []
    private let sourceLocationConverter: SourceLocationConverter
    private let builder: Builder
    private var currentItem: MemberBlockItemSyntax?
    private var depth = 0

    func process(_ item: MemberBlockItemSyntax) {
        currentItem = item
        walk(item)
        currentItem = nil
    }

    // MARK: - Properties

    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }

        let isStatic = node.modifiers.contains { $0.name.tokenKind == .keyword(.static) }
        let isClass = node.modifiers.contains { $0.name.tokenKind == .keyword(.class) }
        let kind: MemberKind = (isStatic || isClass) ? .typeProperty : .instanceProperty
        let visibility = extractVisibility(from: node.modifiers)
        let isAnnotated = !node.attributes.isEmpty

        for binding in node.bindings {
            let name = binding.pattern.description.trimmingCharacters(in: .whitespaces)
            record(
                MemberDiscoveryInfo(
                    name: name,
                    kind: kind,
                    position: node.positionAfterSkippingLeadingTrivia,
                    item: item,
                    visibility: visibility,
                    isAnnotated: isAnnotated
                ))
        }

        return .skipChildren
    }

    // MARK: - Initializers

    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberDiscoveryInfo(
                name: "init",
                kind: .initializer,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: extractVisibility(from: node.modifiers),
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    override func visit(_ node: DeinitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberDiscoveryInfo(
                name: "deinit",
                kind: .deinitializer,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: .internalAccess,
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    // MARK: - Methods

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }

        let isStatic = node.modifiers.contains { $0.name.tokenKind == .keyword(.static) }
        let isClass = node.modifiers.contains { $0.name.tokenKind == .keyword(.class) }
        let kind: MemberKind = (isStatic || isClass) ? .typeMethod : .instanceMethod

        record(
            MemberDiscoveryInfo(
                name: node.name.text,
                kind: kind,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: extractVisibility(from: node.modifiers),
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    override func visit(_ node: SubscriptDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberDiscoveryInfo(
                name: "subscript",
                kind: .subscriptMember,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: extractVisibility(from: node.modifiers),
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    // MARK: - Type Aliases

    override func visit(_ node: TypeAliasDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberDiscoveryInfo(
                name: node.name.text,
                kind: .typeAlias,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: extractVisibility(from: node.modifiers),
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    override func visit(_ node: AssociatedTypeDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberDiscoveryInfo(
                name: node.name.text,
                kind: .associatedType,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: .internalAccess,
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    // MARK: - Nested Types

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        recordNestedTypeIfNeeded(
            name: node.name.text,
            position: node.positionAfterSkippingLeadingTrivia,
            modifiers: node.modifiers,
            attributes: node.attributes
        )
        depth += 1
        return .visitChildren
    }

    override func visitPost(_: ClassDeclSyntax) { depth -= 1 }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        recordNestedTypeIfNeeded(
            name: node.name.text,
            position: node.positionAfterSkippingLeadingTrivia,
            modifiers: node.modifiers,
            attributes: node.attributes
        )
        depth += 1
        return .visitChildren
    }

    override func visitPost(_: StructDeclSyntax) { depth -= 1 }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        recordNestedTypeIfNeeded(
            name: node.name.text,
            position: node.positionAfterSkippingLeadingTrivia,
            modifiers: node.modifiers,
            attributes: node.attributes
        )
        depth += 1
        return .visitChildren
    }

    override func visitPost(_: EnumDeclSyntax) { depth -= 1 }

    override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
        recordNestedTypeIfNeeded(
            name: node.name.text,
            position: node.positionAfterSkippingLeadingTrivia,
            modifiers: node.modifiers,
            attributes: node.attributes
        )
        depth += 1
        return .visitChildren
    }

    override func visitPost(_: ActorDeclSyntax) { depth -= 1 }

    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        recordNestedTypeIfNeeded(
            name: node.name.text,
            position: node.positionAfterSkippingLeadingTrivia,
            modifiers: node.modifiers,
            attributes: node.attributes
        )
        depth += 1
        return .visitChildren
    }

    override func visitPost(_: ProtocolDeclSyntax) { depth -= 1 }

    // MARK: - Private Helpers

    private func recordNestedTypeIfNeeded(
        name: String,
        position: AbsolutePosition,
        modifiers: DeclModifierListSyntax,
        attributes: AttributeListSyntax
    ) {
        guard depth == 0, let item = currentItem else { return }
        record(
            MemberDiscoveryInfo(
                name: name,
                kind: .subtype,
                position: position,
                item: item,
                visibility: extractVisibility(from: modifiers),
                isAnnotated: !attributes.isEmpty
            ))
    }

    private func record(_ info: MemberDiscoveryInfo) {
        let output = builder.build(from: info, using: sourceLocationConverter)
        members.append(output)
    }

    private func extractVisibility(from modifiers: DeclModifierListSyntax) -> Visibility {
        for modifier in modifiers {
            switch modifier.name.tokenKind {
            case .keyword(.open):
                return .openAccess
            case .keyword(.public):
                return .publicAccess
            case .keyword(.internal):
                return .internalAccess
            case .keyword(.fileprivate):
                return .filePrivateAccess
            case .keyword(.private):
                return .privateAccess
            default:
                continue
            }
        }
        return .internalAccess
    }
}
