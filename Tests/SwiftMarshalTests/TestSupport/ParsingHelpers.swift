import SwiftParser
import SwiftSyntax

@testable import swift_marshal

// MARK: - Parse Helpers

func makeParseOutput(source: String, path: String = "Test.swift") -> ParseOutput {
    let syntax = Parser.parse(source: source)
    let converter = SourceLocationConverter(fileName: path, tree: syntax)
    return ParseOutput(path: path, syntax: syntax, locationConverter: converter)
}

// MARK: - Type Discovery Helpers

func discoverTypes(in source: String) -> [TypeDeclaration] {
    let syntax = Parser.parse(source: source)
    let converter = SourceLocationConverter(fileName: "Test.swift", tree: syntax)
    let visitor = UnifiedTypeDiscoveryVisitor.forDeclarations(converter: converter)
    visitor.walk(syntax)
    return visitor.declarations
}

// MARK: - Classification Helpers

func classify(_ source: String) throws -> ClassifyOutput {
    let parseOutput = makeParseOutput(source: source)
    let stage = ClassifyStage()
    return try stage.process(parseOutput)
}

// MARK: - Member Discovery Helpers

func discoverMembers(in source: String) -> [MemberDeclaration] {
    let wrappedSource = "struct Test {\n\(source)\n}"
    let syntax = Parser.parse(source: wrappedSource)
    let converter = SourceLocationConverter(fileName: "Test.swift", tree: syntax)

    guard let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self) else {
        return []
    }

    let visitor = UnifiedMemberDiscoveryVisitor(
        sourceLocationConverter: converter,
        builder: MemberDeclarationBuilder()
    )
    for item in structDecl.memberBlock.members {
        visitor.process(item)
    }
    return visitor.members
}

func discoverMembersInProtocol(in source: String) -> [MemberDeclaration] {
    let wrappedSource = "protocol Test {\n\(source)\n}"
    let syntax = Parser.parse(source: wrappedSource)
    let converter = SourceLocationConverter(fileName: "Test.swift", tree: syntax)

    guard let protocolDecl = syntax.statements.first?.item.as(ProtocolDeclSyntax.self) else {
        return []
    }

    let visitor = UnifiedMemberDiscoveryVisitor(
        sourceLocationConverter: converter,
        builder: MemberDeclarationBuilder()
    )
    for item in protocolDecl.memberBlock.members {
        visitor.process(item)
    }
    return visitor.members
}

// MARK: - Syntax Classification Helpers

func syntaxClassify(_ source: String) throws -> SyntaxClassifyOutput {
    let parseOutput = makeParseOutput(source: source)
    let stage = SyntaxClassifyStage()
    return try stage.process(parseOutput)
}

// MARK: - Rewrite Helpers

func makeRewritePlan(from source: String) throws -> RewritePlanOutput {
    let pipeline = ParseStage()
        .then(SyntaxClassifyStage())
        .then(RewritePlanStage())

    let input = ParseInput(path: "Test.swift", source: source)
    return try pipeline.process(input)
}

func applyRewrite(to source: String) throws -> String {
    let pipeline = ParseStage()
        .then(SyntaxClassifyStage())
        .then(RewritePlanStage())
        .then(ApplyRewriteStage())

    let input = ParseInput(path: "Test.swift", source: source)
    let output = try pipeline.process(input)

    return output.source
}

func discoverSyntaxTypes(in source: String) -> [SyntaxTypeDeclaration] {
    let syntax = Parser.parse(source: source)
    let converter = SourceLocationConverter(fileName: "Test.swift", tree: syntax)
    let visitor = UnifiedTypeDiscoveryVisitor.forSyntaxDeclarations(converter: converter)
    visitor.walk(syntax)
    return visitor.declarations
}

func applyRewriteWithCustomPlan(to source: String, plans: [TypeRewritePlan]) -> String {
    let syntax = Parser.parse(source: source)
    let rewriter = MemberReorderingRewriter(plans: plans)
    let rewritten = rewriter.rewrite(syntax)
    return rewritten.description
}
