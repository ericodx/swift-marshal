import Testing

@testable import swift_marshal

@Suite("ReportOutput Tests")
struct ReportOutputTests {

    // MARK: - Tests

    @Test("Given ReportOutput, when accessing path, then returns correct path")
    func accessesPath() {
        let output = ReportOutput(path: "/path/to/file.swift", text: "", declarationCount: 0)

        #expect(output.path == "/path/to/file.swift")
    }

    @Test("Given ReportOutput, when accessing text, then returns correct text")
    func accessesText() {
        let text = "Test report content"
        let output = ReportOutput(path: "Test.swift", text: text, declarationCount: 0)

        #expect(output.text == text)
    }

    @Test("Given ReportOutput, when accessing declarationCount, then returns correct count")
    func accessesDeclarationCount() {
        let output = ReportOutput(path: "Test.swift", text: "", declarationCount: 5)

        #expect(output.declarationCount == 5)
    }

    @Test("Given ReportOutput with multiline text, when accessing text, then preserves formatting")
    func preservesMultilineText() {
        let text = """
            Line 1
            Line 2
            Line 3
            """
        let output = ReportOutput(path: "Test.swift", text: text, declarationCount: 0)

        #expect(output.text.contains("\n"))
        #expect(output.text.contains("Line 1"))
        #expect(output.text.contains("Line 3"))
    }
}
