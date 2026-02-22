import Testing

@testable import swift_marshal

@Suite("ClassifyOutput Tests")
struct ClassifyOutputTests {

    // MARK: - Tests

    @Test("Given ClassifyOutput, when accessing path, then returns correct path")
    func accessesPath() {
        let output = ClassifyOutput(path: "/path/to/file.swift", declarations: [])

        #expect(output.path == "/path/to/file.swift")
    }

    @Test("Given ClassifyOutput, when accessing declarations, then returns declarations array")
    func accessesDeclarations() {
        let declarations = [
            TypeDeclaration(name: "Test", kind: .structType, line: 1)
        ]
        let output = ClassifyOutput(path: "Test.swift", declarations: declarations)

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].name == "Test")
    }

    @Test("Given ClassifyOutput with empty declarations, when accessing declarations, then returns empty array")
    func handlesEmptyDeclarations() {
        let output = ClassifyOutput(path: "Empty.swift", declarations: [])

        #expect(output.declarations.isEmpty)
    }

    @Test("Given ClassifyOutput with multiple declarations, when accessing declarations, then returns all")
    func handlesMultipleDeclarations() {
        let declarations = [
            TypeDeclaration(name: "First", kind: .structType, line: 1),
            TypeDeclaration(name: "Second", kind: .classType, line: 5),
            TypeDeclaration(name: "Third", kind: .enumType, line: 10),
        ]
        let output = ClassifyOutput(path: "Test.swift", declarations: declarations)

        #expect(output.declarations.count == 3)
    }
}
