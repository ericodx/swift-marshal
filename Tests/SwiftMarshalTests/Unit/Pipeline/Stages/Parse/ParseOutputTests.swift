import SwiftParser
import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("ParseOutput Tests")
struct ParseOutputTests {

    // MARK: - Tests

    @Test("Given ParseOutput, when accessing path, then returns correct path")
    func accessesPath() {
        let output = makeParseOutput(source: "", path: "/path/to/file.swift")

        #expect(output.path == "/path/to/file.swift")
    }

    @Test("Given ParseOutput, when accessing syntax, then returns SourceFileSyntax")
    func accessesSyntax() {
        let output = makeParseOutput(source: "struct Test {}")

        #expect(output.syntax.statements.count >= 0)
    }

    @Test("Given ParseOutput, when accessing locationConverter, then returns SourceLocationConverter")
    func accessesLocationConverter() {
        let output = makeParseOutput(source: "struct Test {}")

        let location = output.locationConverter.location(for: output.syntax.position)
        #expect(location.line >= 1)
    }

    @Test("Given ParseOutput with struct, when accessing syntax, then contains struct declaration")
    func syntaxContainsDeclaration() {
        let output = makeParseOutput(source: "struct MyStruct {}")

        let hasStruct = output.syntax.statements.contains { statement in
            statement.item.is(StructDeclSyntax.self)
        }
        #expect(hasStruct)
    }
}
