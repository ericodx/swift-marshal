import Testing

@testable import swift_marshal

@Suite("ReorderStage Tests")
struct ReorderStageTests {

    // MARK: - Properties

    let stage = ReorderStage()

    // MARK: - Tests

    @Test("Given an empty declarations list, when processing with ReorderStage, then processes empty declarations")
    func emptyDeclarations() throws {
        let input = ClassifyOutput(path: "Test.swift", declarations: [])
        let output = try stage.process(input)

        #expect(output.path == "Test.swift")
        #expect(output.results.isEmpty)
    }

    @Test(
        "Given a type declaration with specific info, when processing with ReorderStage, then preserves type info in result"
    )
    func preservesTypeInfo() throws {
        let decl = TypeDeclaration(name: "Foo", kind: .structType, line: 1, members: [])
        let input = ClassifyOutput(path: "Test.swift", declarations: [decl])
        let output = try stage.process(input)

        #expect(output.results.count == 1)
        #expect(output.results[0].name == "Foo")
        #expect(output.results[0].kind == .structType)
        #expect(output.results[0].line == 1)
    }

    @Test(
        "Given a type with original and reordered members, when processing with ReorderStage, then includes original and reordered members"
    )
    func includesOriginalAndReordered() throws {
        let members = [
            MemberDeclaration(name: "doSomething", kind: .instanceMethod, line: 2),
            MemberDeclaration(name: "init", kind: .initializer, line: 3),
        ]
        let decl = TypeDeclaration(name: "Foo", kind: .structType, line: 1, members: members)
        let input = ClassifyOutput(path: "Test.swift", declarations: [decl])
        let output = try stage.process(input)

        let result = output.results[0]
        #expect(result.originalMembers[0].kind == .instanceMethod)
        #expect(result.originalMembers[1].kind == .initializer)
        #expect(result.reorderedMembers[0].kind == .initializer)
        #expect(result.reorderedMembers[1].kind == .instanceMethod)
    }

    @Test(
        "Given a type with members out of order, when processing with ReorderStage, then detects when reordering needed"
    )
    func detectsReorderingNeeded() throws {
        let members = [
            MemberDeclaration(name: "doSomething", kind: .instanceMethod, line: 2),
            MemberDeclaration(name: "init", kind: .initializer, line: 3),
        ]
        let decl = TypeDeclaration(name: "Foo", kind: .structType, line: 1, members: members)
        let input = ClassifyOutput(path: "Test.swift", declarations: [decl])
        let output = try stage.process(input)

        #expect(output.results[0].needsReordering)
    }

    @Test(
        "Given a type with correctly ordered members, when processing with ReorderStage, then detects when order is correct"
    )
    func detectsCorrectOrder() throws {
        let members = [
            MemberDeclaration(name: "init", kind: .initializer, line: 2),
            MemberDeclaration(name: "doSomething", kind: .instanceMethod, line: 3),
        ]
        let decl = TypeDeclaration(name: "Foo", kind: .structType, line: 1, members: members)
        let input = ClassifyOutput(path: "Test.swift", declarations: [decl])
        let output = try stage.process(input)

        #expect(!output.results[0].needsReordering)
    }
}
