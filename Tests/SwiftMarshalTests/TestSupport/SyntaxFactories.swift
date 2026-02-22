import SwiftParser
import SwiftSyntax

@testable import swift_marshal

// MARK: - MemberDiscoveryInfo Factory

func makeMemberDiscoveryInfo(
    name: String = "test",
    kind: MemberKind = .instanceProperty,
    visibility: Visibility = .internalAccess,
    isAnnotated: Bool = false
) -> MemberDiscoveryInfo {
    let source = "struct Test { var \(name): Int }"
    let syntax = Parser.parse(source: source)

    guard let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self),
        let firstMember = structDecl.memberBlock.members.first
    else {
        fatalError("Failed to parse test source")
    }

    return MemberDiscoveryInfo(
        name: name,
        kind: kind,
        position: firstMember.positionAfterSkippingLeadingTrivia,
        item: firstMember,
        visibility: visibility,
        isAnnotated: isAnnotated
    )
}

func makeMemberDiscoveryInfoWithConverter(
    name: String,
    kind: MemberKind,
    visibility: Visibility = .internalAccess,
    isAnnotated: Bool = false
) -> (MemberDiscoveryInfo, SourceLocationConverter) {
    let source = "struct Test { var \(name): Int }"
    let syntax = Parser.parse(source: source)
    let converter = SourceLocationConverter(fileName: "Test.swift", tree: syntax)

    guard let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self),
        let firstMember = structDecl.memberBlock.members.first
    else {
        fatalError("Failed to parse test source")
    }

    let info = MemberDiscoveryInfo(
        name: name,
        kind: kind,
        position: firstMember.positionAfterSkippingLeadingTrivia,
        item: firstMember,
        visibility: visibility,
        isAnnotated: isAnnotated
    )

    return (info, converter)
}

// MARK: - TypeDiscoveryInfo Factory

func makeTypeDiscoveryInfo(
    name: String = "Test",
    kind: TypeKind = .structType,
    members: [MemberDeclaration] = []
) -> TypeDiscoveryInfo<MemberDeclaration> {
    let source: String
    switch kind {
    case .structType:
        source = "struct \(name) {}"
    case .classType:
        source = "class \(name) {}"
    case .enumType:
        source = "enum \(name) {}"
    case .actorType:
        source = "actor \(name) {}"
    case .protocolType:
        source = "protocol \(name) {}"
    }

    let syntax = Parser.parse(source: source)
    let memberBlock: MemberBlockSyntax
    let position: AbsolutePosition

    if let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self) {
        memberBlock = structDecl.memberBlock
        position = structDecl.positionAfterSkippingLeadingTrivia
    } else if let classDecl = syntax.statements.first?.item.as(ClassDeclSyntax.self) {
        memberBlock = classDecl.memberBlock
        position = classDecl.positionAfterSkippingLeadingTrivia
    } else if let enumDecl = syntax.statements.first?.item.as(EnumDeclSyntax.self) {
        memberBlock = enumDecl.memberBlock
        position = enumDecl.positionAfterSkippingLeadingTrivia
    } else if let actorDecl = syntax.statements.first?.item.as(ActorDeclSyntax.self) {
        memberBlock = actorDecl.memberBlock
        position = actorDecl.positionAfterSkippingLeadingTrivia
    } else if let protocolDecl = syntax.statements.first?.item.as(ProtocolDeclSyntax.self) {
        memberBlock = protocolDecl.memberBlock
        position = protocolDecl.positionAfterSkippingLeadingTrivia
    } else {
        fatalError("Failed to parse test source")
    }

    return TypeDiscoveryInfo(
        name: name,
        kind: kind,
        position: position,
        members: members,
        memberBlock: memberBlock
    )
}

func makeTypeDiscoveryInfoWithConverter(
    name: String,
    kind: TypeKind,
    members: [MemberDeclaration] = []
) -> (TypeDiscoveryInfo<MemberDeclaration>, SourceLocationConverter) {
    let source: String
    switch kind {
    case .structType:
        source = "struct \(name) {}"
    case .classType:
        source = "class \(name) {}"
    case .enumType:
        source = "enum \(name) {}"
    case .actorType:
        source = "actor \(name) {}"
    case .protocolType:
        source = "protocol \(name) {}"
    }

    let syntax = Parser.parse(source: source)
    let converter = SourceLocationConverter(fileName: "Test.swift", tree: syntax)

    let memberBlock: MemberBlockSyntax
    let position: AbsolutePosition

    if let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self) {
        memberBlock = structDecl.memberBlock
        position = structDecl.positionAfterSkippingLeadingTrivia
    } else if let classDecl = syntax.statements.first?.item.as(ClassDeclSyntax.self) {
        memberBlock = classDecl.memberBlock
        position = classDecl.positionAfterSkippingLeadingTrivia
    } else if let enumDecl = syntax.statements.first?.item.as(EnumDeclSyntax.self) {
        memberBlock = enumDecl.memberBlock
        position = enumDecl.positionAfterSkippingLeadingTrivia
    } else if let actorDecl = syntax.statements.first?.item.as(ActorDeclSyntax.self) {
        memberBlock = actorDecl.memberBlock
        position = actorDecl.positionAfterSkippingLeadingTrivia
    } else if let protocolDecl = syntax.statements.first?.item.as(ProtocolDeclSyntax.self) {
        memberBlock = protocolDecl.memberBlock
        position = protocolDecl.positionAfterSkippingLeadingTrivia
    } else {
        fatalError("Failed to parse test source")
    }

    let info = TypeDiscoveryInfo(
        name: name,
        kind: kind,
        position: position,
        members: members,
        memberBlock: memberBlock
    )

    return (info, converter)
}

func makeSyntaxTypeDiscoveryInfoWithConverter(
    name: String,
    kind: TypeKind
) -> (TypeDiscoveryInfo<SyntaxMemberDeclaration>, SourceLocationConverter) {
    let source: String
    switch kind {
    case .structType:
        source = "struct \(name) {}"
    case .classType:
        source = "class \(name) {}"
    case .enumType:
        source = "enum \(name) {}"
    case .actorType:
        source = "actor \(name) {}"
    case .protocolType:
        source = "protocol \(name) {}"
    }

    let syntax = Parser.parse(source: source)
    let converter = SourceLocationConverter(fileName: "Test.swift", tree: syntax)

    let memberBlock: MemberBlockSyntax
    let position: AbsolutePosition

    if let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self) {
        memberBlock = structDecl.memberBlock
        position = structDecl.positionAfterSkippingLeadingTrivia
    } else if let classDecl = syntax.statements.first?.item.as(ClassDeclSyntax.self) {
        memberBlock = classDecl.memberBlock
        position = classDecl.positionAfterSkippingLeadingTrivia
    } else if let enumDecl = syntax.statements.first?.item.as(EnumDeclSyntax.self) {
        memberBlock = enumDecl.memberBlock
        position = enumDecl.positionAfterSkippingLeadingTrivia
    } else if let actorDecl = syntax.statements.first?.item.as(ActorDeclSyntax.self) {
        memberBlock = actorDecl.memberBlock
        position = actorDecl.positionAfterSkippingLeadingTrivia
    } else if let protocolDecl = syntax.statements.first?.item.as(ProtocolDeclSyntax.self) {
        memberBlock = protocolDecl.memberBlock
        position = protocolDecl.positionAfterSkippingLeadingTrivia
    } else {
        fatalError("Failed to parse test source")
    }

    let info = TypeDiscoveryInfo<SyntaxMemberDeclaration>(
        name: name,
        kind: kind,
        position: position,
        members: [],
        memberBlock: memberBlock
    )

    return (info, converter)
}
