import Testing

@testable import swift_marshal

@Suite("TypeReorderResult Tests")
struct TypeReorderResultTests {

    // MARK: - Tests

    @Test("Given TypeReorderResult, when accessing name, then returns correct name")
    func accessesName() {
        let result = makeTypeReorderResult(name: "MyStruct")

        #expect(result.name == "MyStruct")
    }

    @Test("Given TypeReorderResult, when accessing kind, then returns correct kind")
    func accessesKind() {
        let result = makeTypeReorderResult(kind: .classType)

        #expect(result.kind == .classType)
    }

    @Test("Given TypeReorderResult, when accessing line, then returns correct line")
    func accessesLine() {
        let result = makeTypeReorderResult(line: 10)

        #expect(result.line == 10)
    }

    @Test("Given TypeReorderResult, when accessing originalMembers, then returns original members")
    func accessesOriginalMembers() {
        let members = [
            MemberDeclaration(name: "x", kind: .instanceProperty, line: 2),
            MemberDeclaration(name: "init", kind: .initializer, line: 3),
        ]
        let result = makeTypeReorderResult(originalMembers: members)

        #expect(result.originalMembers.count == 2)
        #expect(result.originalMembers[0].name == "x")
    }

    @Test("Given TypeReorderResult, when accessing reorderedMembers, then returns reordered members")
    func accessesReorderedMembers() {
        let original = [
            MemberDeclaration(name: "x", kind: .instanceProperty, line: 2),
            MemberDeclaration(name: "init", kind: .initializer, line: 3),
        ]
        let reordered = [
            MemberDeclaration(name: "init", kind: .initializer, line: 3),
            MemberDeclaration(name: "x", kind: .instanceProperty, line: 2),
        ]
        let result = TypeReorderResult(
            name: "Test",
            kind: .structType,
            line: 1,
            originalMembers: original,
            reorderedMembers: reordered
        )

        #expect(result.reorderedMembers.count == 2)
        #expect(result.reorderedMembers[0].name == "init")
    }

    @Test("Given TypeReorderResult with different member order, when checking needsReordering, then returns true")
    func needsReorderingTrue() {
        let original = [
            MemberDeclaration(name: "method", kind: .instanceMethod, line: 2),
            MemberDeclaration(name: "init", kind: .initializer, line: 3),
        ]
        let reordered = [
            MemberDeclaration(name: "init", kind: .initializer, line: 3),
            MemberDeclaration(name: "method", kind: .instanceMethod, line: 2),
        ]
        let result = TypeReorderResult(
            name: "Test",
            kind: .structType,
            line: 1,
            originalMembers: original,
            reorderedMembers: reordered
        )

        #expect(result.needsReordering == true)
    }

    @Test("Given TypeReorderResult with same member order, when checking needsReordering, then returns false")
    func needsReorderingFalse() {
        let members = [
            MemberDeclaration(name: "init", kind: .initializer, line: 2),
            MemberDeclaration(name: "method", kind: .instanceMethod, line: 3),
        ]
        let result = TypeReorderResult(
            name: "Test",
            kind: .structType,
            line: 1,
            originalMembers: members,
            reorderedMembers: members
        )

        #expect(result.needsReordering == false)
    }
}
