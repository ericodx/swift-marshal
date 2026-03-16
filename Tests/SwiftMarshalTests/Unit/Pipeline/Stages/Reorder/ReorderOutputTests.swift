import Testing

@testable import swift_marshal

@Suite("ReorderOutput Tests")
struct ReorderOutputTests {

    // MARK: - Tests

    @Test("Given ReorderOutput, when accessing path, then returns correct path")
    func accessesPath() {
        let output = ReorderOutput(path: "/path/to/file.swift", results: [])

        #expect(output.path == "/path/to/file.swift")
    }

    @Test("Given ReorderOutput, when accessing results, then returns results array")
    func accessesResults() {
        let results = [
            TypeReorderResult(
                name: "Test",
                kind: .structType,
                line: 1,
                originalMembers: [],
                reorderedMembers: []
            )
        ]
        let output = ReorderOutput(path: "Test.swift", results: results)

        #expect(output.results.count == 1)
        #expect(output.results[0].name == "Test")
    }

    @Test("Given ReorderOutput with empty results, when accessing results, then returns empty array")
    func handlesEmptyResults() {
        let output = ReorderOutput(path: "Empty.swift", results: [])

        #expect(output.results.isEmpty)
    }

    @Test("Given ReorderOutput with multiple results, when accessing results, then returns all")
    func handlesMultipleResults() {
        let results = [
            TypeReorderResult(name: "A", kind: .structType, line: 1, originalMembers: [], reorderedMembers: []),
            TypeReorderResult(name: "B", kind: .classType, line: 5, originalMembers: [], reorderedMembers: []),
        ]
        let output = ReorderOutput(path: "Test.swift", results: results)

        #expect(output.results.count == 2)
    }
}
