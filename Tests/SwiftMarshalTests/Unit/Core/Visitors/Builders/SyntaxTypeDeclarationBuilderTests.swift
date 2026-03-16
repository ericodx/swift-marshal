import SwiftParser
import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("SyntaxTypeDeclarationBuilder Tests")
struct SyntaxTypeDeclarationBuilderTests {

    // MARK: - Properties

    let builder = SyntaxTypeDeclarationBuilder()

    // MARK: - Tests

    @Test("Given type info, when building, then creates SyntaxTypeDeclaration with correct name")
    func createsWithCorrectName() {
        let (info, converter) = makeSyntaxTypeDiscoveryInfoWithConverter(name: "MyEnum", kind: .enumType)

        let result = builder.build(from: info, using: converter)

        #expect(result.name == "MyEnum")
    }

    @Test("Given type info, when building, then creates SyntaxTypeDeclaration with correct kind")
    func createsWithCorrectKind() {
        let (info, converter) = makeSyntaxTypeDiscoveryInfoWithConverter(name: "MyClass", kind: .classType)

        let result = builder.build(from: info, using: converter)

        #expect(result.kind == .classType)
    }

    @Test("Given type info, when building, then creates SyntaxTypeDeclaration with memberBlock reference")
    func createsWithMemberBlockReference() {
        let (info, converter) = makeSyntaxTypeDiscoveryInfoWithConverter(name: "Test", kind: .structType)

        let result = builder.build(from: info, using: converter)

        #expect(result.memberBlock == info.memberBlock)
    }

    @Test("Given type info with members, when building, then preserves syntax members")
    func preservesSyntaxMembers() {
        let source = """
            struct Test {
                var x: Int
            }
            """
        let syntax = Parser.parse(source: source)
        let converter = SourceLocationConverter(fileName: "Test.swift", tree: syntax)

        guard let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self),
            let firstMember = structDecl.memberBlock.members.first
        else {
            Issue.record("Failed to parse")
            return
        }

        let syntaxMember = SyntaxMemberDeclaration(
            declaration: MemberDeclaration(name: "x", kind: .instanceProperty, line: 2),
            syntax: firstMember
        )
        let info = TypeDiscoveryInfo(
            name: "Test",
            kind: .structType,
            position: structDecl.positionAfterSkippingLeadingTrivia,
            members: [syntaxMember],
            memberBlock: structDecl.memberBlock
        )

        let result = builder.build(from: info, using: converter)

        #expect(result.members.count == 1)
        #expect(result.members[0].declaration.name == "x")
    }

    @Test("Given type info, when building, then creates SyntaxTypeDeclaration with correct line")
    func createsWithCorrectLine() {
        let (info, converter) = makeSyntaxTypeDiscoveryInfoWithConverter(name: "Test", kind: .structType)

        let result = builder.build(from: info, using: converter)

        #expect(result.line >= 1)
    }
}
