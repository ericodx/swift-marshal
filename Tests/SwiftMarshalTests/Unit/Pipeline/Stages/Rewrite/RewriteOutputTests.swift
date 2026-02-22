import Testing

@testable import swift_marshal

@Suite("RewriteOutput Tests")
struct RewriteOutputTests {

    // MARK: - Tests

    @Test("Given RewriteOutput, when accessing path, then returns correct path")
    func accessesPath() {
        let output = RewriteOutput(path: "/path/to/file.swift", source: "", modified: false)

        #expect(output.path == "/path/to/file.swift")
    }

    @Test("Given RewriteOutput, when accessing source, then returns correct source")
    func accessesSource() {
        let source = "struct Test {}"
        let output = RewriteOutput(path: "Test.swift", source: source, modified: false)

        #expect(output.source == source)
    }

    @Test("Given RewriteOutput with modified true, when accessing modified, then returns true")
    func accessesModifiedTrue() {
        let output = RewriteOutput(path: "Test.swift", source: "", modified: true)

        #expect(output.modified == true)
    }

    @Test("Given RewriteOutput with modified false, when accessing modified, then returns false")
    func accessesModifiedFalse() {
        let output = RewriteOutput(path: "Test.swift", source: "", modified: false)

        #expect(output.modified == false)
    }

    @Test("Given RewriteOutput with multiline source, when accessing source, then preserves formatting")
    func preservesSourceFormatting() {
        let source = """
            struct Test {
                var x: Int
                init() {}
            }
            """
        let output = RewriteOutput(path: "Test.swift", source: source, modified: true)

        #expect(output.source.contains("var x: Int"))
        #expect(output.source.contains("init()"))
    }
}
