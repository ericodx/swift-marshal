import Testing

@testable import swift_marshal

@Suite("ParseInput Tests")
struct ParseInputTests {

    // MARK: - Tests

    @Test("Given ParseInput, when accessing path, then returns correct path")
    func accessesPath() {
        let input = ParseInput(path: "/path/to/file.swift", source: "")

        #expect(input.path == "/path/to/file.swift")
    }

    @Test("Given ParseInput, when accessing source, then returns correct source")
    func accessesSource() {
        let source = "struct Test {}"
        let input = ParseInput(path: "Test.swift", source: source)

        #expect(input.source == source)
    }

    @Test("Given ParseInput with empty source, when accessing source, then returns empty string")
    func handlesEmptySource() {
        let input = ParseInput(path: "Empty.swift", source: "")

        #expect(input.source.isEmpty)
    }

    @Test("Given ParseInput with multiline source, when accessing source, then preserves newlines")
    func preservesNewlines() {
        let source = """
            struct Test {
                var x: Int
            }
            """
        let input = ParseInput(path: "Test.swift", source: source)

        #expect(input.source.contains("\n"))
    }
}
