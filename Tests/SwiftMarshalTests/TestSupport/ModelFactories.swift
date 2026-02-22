import SwiftParser
import SwiftSyntax

@testable import swift_marshal

// MARK: - TypeReorderResult Factory

func makeTypeReorderResult(
    name: String = "Test",
    kind: TypeKind = .structType,
    line: Int = 1,
    originalMembers: [MemberDeclaration] = [],
    reorderedMembers: [MemberDeclaration]? = nil
) -> TypeReorderResult {
    TypeReorderResult(
        name: name,
        kind: kind,
        line: line,
        originalMembers: originalMembers,
        reorderedMembers: reorderedMembers ?? originalMembers
    )
}

// MARK: - TypeRewritePlan Factory

func makeTypeRewritePlan(
    typeName: String = "Test",
    kind: TypeKind = .structType,
    line: Int = 1,
    originalMembers: [SyntaxMemberDeclaration] = [],
    reorderedMembers: [IndexedSyntaxMember]? = nil
) -> TypeRewritePlan {
    let indexed =
        reorderedMembers
        ?? originalMembers.enumerated().map { index, member in
            IndexedSyntaxMember(member: member, originalIndex: index)
        }
    return TypeRewritePlan(
        typeName: typeName,
        kind: kind,
        line: line,
        originalMembers: originalMembers,
        reorderedMembers: indexed
    )
}

func makeIndexedMembers(from members: [SyntaxMemberDeclaration]) -> [IndexedSyntaxMember] {
    members.enumerated().map { index, member in
        IndexedSyntaxMember(member: member, originalIndex: index)
    }
}

func makeReorderedIndexedMembers(
    from original: [SyntaxMemberDeclaration],
    reorderedIndices: [Int]
) -> [IndexedSyntaxMember] {
    reorderedIndices.map { index in
        IndexedSyntaxMember(member: original[index], originalIndex: index)
    }
}

// MARK: - SyntaxMemberDeclaration Factory

func makeSyntaxMembers(
    names: [String],
    kinds: [MemberKind]? = nil
) -> [SyntaxMemberDeclaration] {
    let source = "struct Test { var placeholder: Int }"
    let syntax = Parser.parse(source: source)

    guard let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self),
        let memberItem = structDecl.memberBlock.members.first
    else {
        return []
    }

    let resolvedKinds = kinds ?? Array(repeating: MemberKind.instanceProperty, count: names.count)

    return zip(names, resolvedKinds).map { name, kind in
        let declaration = MemberDeclaration(name: name, kind: kind, line: 1)
        return SyntaxMemberDeclaration(declaration: declaration, syntax: memberItem)
    }
}

func makeSyntaxMember(name: String, kind: MemberKind = .instanceProperty) -> SyntaxMemberDeclaration {
    let source = "struct Test { var \(name): Int }"
    let syntax = Parser.parse(source: source)

    guard let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self),
        let memberItem = structDecl.memberBlock.members.first
    else {
        fatalError("Failed to parse test source")
    }

    let declaration = MemberDeclaration(name: name, kind: kind, line: 1)
    return SyntaxMemberDeclaration(declaration: declaration, syntax: memberItem)
}

func makeSyntaxMemberDeclaration(
    name: String,
    kind: MemberKind
) -> (SyntaxMemberDeclaration, MemberBlockItemSyntax) {
    let source = "struct Test { var \(name): Int }"
    let syntax = Parser.parse(source: source)

    guard let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self),
        let memberItem = structDecl.memberBlock.members.first
    else {
        fatalError("Failed to parse test source")
    }

    let declaration = MemberDeclaration(name: name, kind: kind, line: 1)
    let syntaxMember = SyntaxMemberDeclaration(declaration: declaration, syntax: memberItem)

    return (syntaxMember, memberItem)
}

func makeMinimalMemberBlockItem() -> MemberBlockItemSyntax {
    let source = "struct Test { var x: Int }"
    let syntax = Parser.parse(source: source)

    guard let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self),
        let memberItem = structDecl.memberBlock.members.first
    else {
        fatalError("Failed to parse test source")
    }

    return memberItem
}

// MARK: - SyntaxTypeDeclaration Factory

func makeSyntaxTypeDeclaration(
    name: String,
    kind: TypeKind,
    line: Int = 1,
    members: [SyntaxMemberDeclaration] = []
) -> SyntaxTypeDeclaration {
    let source = "\(kind.rawValue) \(name) {}"
    let syntax = Parser.parse(source: source)

    let memberBlock: MemberBlockSyntax

    switch kind {
    case .structType:
        memberBlock =
            syntax.statements.first?.item.as(StructDeclSyntax.self)?.memberBlock ?? MemberBlockSyntax(members: [])
    case .classType:
        memberBlock =
            syntax.statements.first?.item.as(ClassDeclSyntax.self)?.memberBlock ?? MemberBlockSyntax(members: [])
    case .enumType:
        memberBlock =
            syntax.statements.first?.item.as(EnumDeclSyntax.self)?.memberBlock ?? MemberBlockSyntax(members: [])
    case .actorType:
        memberBlock =
            syntax.statements.first?.item.as(ActorDeclSyntax.self)?.memberBlock ?? MemberBlockSyntax(members: [])
    case .protocolType:
        memberBlock =
            syntax.statements.first?.item.as(ProtocolDeclSyntax.self)?.memberBlock ?? MemberBlockSyntax(members: [])
    }

    return SyntaxTypeDeclaration(
        name: name,
        kind: kind,
        line: line,
        members: members,
        memberBlock: memberBlock
    )
}
