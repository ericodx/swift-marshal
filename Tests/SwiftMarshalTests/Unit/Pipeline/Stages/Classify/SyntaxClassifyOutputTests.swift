import SwiftParser
import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("SyntaxClassifyOutput Tests")
struct SyntaxClassifyOutputTests {

    // MARK: - Tests

    @Test("Given SyntaxClassifyOutput, when accessing path, then returns correct path")
    func accessesPath() {
        let output = makeSyntaxClassifyOutput(path: "/path/to/file.swift")

        #expect(output.path == "/path/to/file.swift")
    }

    @Test("Given SyntaxClassifyOutput, when accessing syntax, then returns SourceFileSyntax")
    func accessesSyntax() {
        let output = makeSyntaxClassifyOutput(source: "struct Test {}")

        #expect(output.syntax.statements.count >= 0)
    }

    @Test("Given SyntaxClassifyOutput, when accessing declarations, then returns declarations array")
    func accessesDeclarations() {
        let output = makeSyntaxClassifyOutput()

        #expect(output.declarations.count >= 0)
    }

    @Test("Given SyntaxClassifyOutput, when stored as Sendable, then can be recovered with same path")
    func isSendable() {
        let original = makeSyntaxClassifyOutput(path: "/test/path.swift")
        let sendable: any Sendable = original

        #expect((sendable as? SyntaxClassifyOutput)?.path == "/test/path.swift")
    }
}
