import SwiftParser
import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("SyntaxMemberDeclaration Tests")
struct SyntaxMemberDeclarationTests {

    // MARK: - Tests

    @Test("Given SyntaxMemberDeclaration, when accessing declaration, then returns MemberDeclaration")
    func accessesDeclaration() {
        let (syntaxMember, _) = makeSyntaxMemberDeclaration(name: "testProperty", kind: .instanceProperty)

        #expect(syntaxMember.declaration.name == "testProperty")
        #expect(syntaxMember.declaration.kind == .instanceProperty)
    }

    @Test("Given SyntaxMemberDeclaration, when accessing syntax, then returns MemberBlockItemSyntax")
    func accessesSyntax() {
        let (syntaxMember, expectedSyntax) = makeSyntaxMemberDeclaration(name: "test", kind: .instanceProperty)

        #expect(syntaxMember.syntax == expectedSyntax)
    }

    @Test("Given two SyntaxMemberDeclarations with same values, when comparing syntax, then syntax matches")
    func syntaxMatchesOriginal() {
        let (syntaxMember, originalSyntax) = makeSyntaxMemberDeclaration(name: "x", kind: .instanceProperty)

        #expect(syntaxMember.syntax.description == originalSyntax.description)
    }

    @Test("Given SyntaxMemberDeclaration, when declaration has visibility, then preserves visibility")
    func preservesVisibility() {
        let declaration = MemberDeclaration(
            name: "test",
            kind: .instanceProperty,
            line: 1,
            visibility: .privateAccess
        )
        let syntax = makeMinimalMemberBlockItem()

        let syntaxMember = SyntaxMemberDeclaration(declaration: declaration, syntax: syntax)

        #expect(syntaxMember.declaration.visibility == .privateAccess)
    }

    @Test("Given SyntaxMemberDeclaration, when declaration is annotated, then preserves annotation flag")
    func preservesAnnotationFlag() {
        let declaration = MemberDeclaration(
            name: "test",
            kind: .instanceProperty,
            line: 1,
            isAnnotated: true
        )
        let syntax = makeMinimalMemberBlockItem()

        let syntaxMember = SyntaxMemberDeclaration(declaration: declaration, syntax: syntax)

        #expect(syntaxMember.declaration.isAnnotated == true)
    }
}
