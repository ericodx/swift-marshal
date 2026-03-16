import Testing

@testable import swift_marshal

@Suite("ParseStage Tests")
struct ParseStageTests {

    // MARK: - Tests

    @Test(
        "Given a valid Swift source file, when parsing the source, then creates a syntax tree with the expected structure"
    )
    func parsesValidSource() throws {
        let stage = ParseStage()
        let input = ParseInput(
            path: "Test.swift",
            source: "struct Foo {}"
        )

        let output = try stage.process(input)

        #expect(output.path == "Test.swift")
        #expect(output.syntax.statements.count == 1)
    }

    @Test("Given an empty source file, when parsing the source, then creates a syntax tree with no statements")
    func parsesEmptySource() throws {
        let stage = ParseStage()
        let input = ParseInput(path: "Empty.swift", source: "")

        let output = try stage.process(input)

        #expect(output.path == "Empty.swift")
        #expect(output.syntax.statements.isEmpty)
    }

    @Test(
        "Given a source file with a specific path, when parsing the source, then preserves the file path in the output")
    func preservesFilePath() throws {
        let stage = ParseStage()
        let input = ParseInput(
            path: "/some/path/File.swift",
            source: "let x = 1"
        )

        let output = try stage.process(input)

        #expect(output.path == "/some/path/File.swift")
    }

    @Test(
        "Given a multi-line source file, when parsing the source, then creates a valid location converter for line numbers"
    )
    func createsLocationConverter() throws {
        let stage = ParseStage()
        let source = """
            struct First {}
            struct Second {}
            """
        let input = ParseInput(path: "Multi.swift", source: source)

        let output = try stage.process(input)
        let location = output.locationConverter.location(for: output.syntax.position)

        #expect(location.line == 1)
    }
}
