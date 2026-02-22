import Testing

@testable import swift_marshal

@Suite("ReorderReportStage Tests")
struct ReorderReportStageTests {

    let stage = ReorderReportStage()

    // MARK: - Empty Results

    @Test("Given empty results, when processing, then reports no type declarations")
    func reportsNoTypeDeclarations() throws {
        let input = ReorderOutput(path: "Test.swift", results: [])

        let output = try stage.process(input)

        #expect(output.text.contains("(no type declarations)"))
        #expect(output.declarationCount == 0)
    }

    // MARK: - Types Without Members

    @Test("Given type with no members, when processing, then reports no members")
    func reportsNoMembers() throws {
        let result = TypeReorderResult(
            name: "Empty",
            kind: .structType,
            line: 1,
            originalMembers: [],
            reorderedMembers: []
        )
        let input = ReorderOutput(path: "Test.swift", results: [result])

        let output = try stage.process(input)

        #expect(output.text.contains("(no members)"))
    }

    // MARK: - Correctly Ordered Types

    @Test("Given correctly ordered type, when processing, then reports order ok")
    func reportsOrderOk() throws {
        let members = [
            MemberDeclaration(name: "init", kind: .initializer, line: 2),
            MemberDeclaration(name: "doSomething", kind: .instanceMethod, line: 3),
        ]
        let result = TypeReorderResult(
            name: "Ordered",
            kind: .structType,
            line: 1,
            originalMembers: members,
            reorderedMembers: members
        )
        let input = ReorderOutput(path: "Test.swift", results: [result])

        let output = try stage.process(input)

        #expect(output.text.contains("[order ok]"))
        #expect(!output.text.contains("[needs reordering]"))
    }

    // MARK: - Types Needing Reordering

    @Test("Given type needing reordering, when processing, then reports needs reordering")
    func reportsNeedsReordering() throws {
        let original = [
            MemberDeclaration(name: "doSomething", kind: .instanceMethod, line: 2),
            MemberDeclaration(name: "init", kind: .initializer, line: 3),
        ]
        let reordered = [
            MemberDeclaration(name: "init", kind: .initializer, line: 3),
            MemberDeclaration(name: "doSomething", kind: .instanceMethod, line: 2),
        ]
        let result = TypeReorderResult(
            name: "Unordered",
            kind: .structType,
            line: 1,
            originalMembers: original,
            reorderedMembers: reordered
        )
        let input = ReorderOutput(path: "Test.swift", results: [result])

        let output = try stage.process(input)

        #expect(output.text.contains("[needs reordering]"))
        #expect(output.text.contains("original:"))
        #expect(output.text.contains("reordered:"))
    }

    // MARK: - Summary

    @Test("Given multiple types, when processing, then includes correct summary")
    func includesCorrectSummary() throws {
        let orderedResult = TypeReorderResult(
            name: "Ordered",
            kind: .structType,
            line: 1,
            originalMembers: [],
            reorderedMembers: []
        )
        let original = [MemberDeclaration(name: "method", kind: .instanceMethod, line: 11)]
        let reordered = [MemberDeclaration(name: "init", kind: .initializer, line: 12)]
        let unorderedResult = TypeReorderResult(
            name: "Unordered",
            kind: .classType,
            line: 10,
            originalMembers: original,
            reorderedMembers: reordered
        )
        let input = ReorderOutput(path: "Test.swift", results: [orderedResult, unorderedResult])

        let output = try stage.process(input)

        #expect(output.text.contains("Summary: 2 types, 1 need reordering"))
        #expect(output.declarationCount == 2)
    }

    // MARK: - Path

    @Test("Given input with path, when processing, then output includes path")
    func includesPath() throws {
        let input = ReorderOutput(path: "MyFile.swift", results: [])

        let output = try stage.process(input)

        #expect(output.path == "MyFile.swift")
        #expect(output.text.contains("MyFile.swift:"))
    }
}
