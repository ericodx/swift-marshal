import Testing

@testable import swift_marshal

@Suite("ReorderEngine Tests")
struct ReorderEngineTests {

    // MARK: - Properties

    let engine = ReorderEngine(configuration: .defaultValue)

    // MARK: - Tests

    @Test("Given an empty members array, when reordering with ReorderEngine, then returns empty array for empty input")
    func emptyInput() {
        let result = engine.reorder([])
        #expect(result.isEmpty)
    }

    @Test("Given a single member, when reordering with ReorderEngine, then preserves single member")
    func singleMember() {
        let members = [MemberDeclaration(name: "foo", kind: .instanceMethod, line: 1)]
        let result = engine.reorder(members)

        #expect(result.count == 1)
        #expect(result[0].name == "foo")
    }

    @Test(
        "Given typealias and initializer members, when reordering with ReorderEngine, then orders typealias before initializer"
    )
    func typealiasBeforeInitializer() {
        let members = [
            MemberDeclaration(name: "init", kind: .initializer, line: 1),
            MemberDeclaration(name: "ID", kind: .typeAlias, line: 2),
        ]
        let result = engine.reorder(members)

        #expect(result[0].kind == .typeAlias)
        #expect(result[1].kind == .initializer)
    }

    @Test("Orders initializer before properties")
    func initializerBeforeProperties() {
        let members = [
            MemberDeclaration(name: "name", kind: .instanceProperty, line: 1),
            MemberDeclaration(name: "init", kind: .initializer, line: 2),
        ]
        let result = engine.reorder(members)

        #expect(result[0].kind == .initializer)
        #expect(result[1].kind == .instanceProperty)
    }

    @Test("Orders type properties before instance properties")
    func typeBeforeInstanceProperties() {
        let members = [
            MemberDeclaration(name: "name", kind: .instanceProperty, line: 1),
            MemberDeclaration(name: "shared", kind: .typeProperty, line: 2),
        ]
        let result = engine.reorder(members)

        #expect(result[0].kind == .typeProperty)
        #expect(result[1].kind == .instanceProperty)
    }

    @Test("Orders methods after properties")
    func methodsAfterProperties() {
        let members = [
            MemberDeclaration(name: "doSomething", kind: .instanceMethod, line: 1),
            MemberDeclaration(name: "name", kind: .instanceProperty, line: 2),
        ]
        let result = engine.reorder(members)

        #expect(result[0].kind == .instanceProperty)
        #expect(result[1].kind == .instanceMethod)
    }

    @Test("Orders deinitializer last")
    func deinitializerLast() {
        let members = [
            MemberDeclaration(name: "deinit", kind: .deinitializer, line: 1),
            MemberDeclaration(name: "init", kind: .initializer, line: 2),
            MemberDeclaration(name: "name", kind: .instanceProperty, line: 3),
        ]
        let result = engine.reorder(members)

        #expect(result[0].kind == .initializer)
        #expect(result[1].kind == .instanceProperty)
        #expect(result[2].kind == .deinitializer)
    }

    @Test("Stable sort within same kind")
    func stableSortWithinKind() {
        let members = [
            MemberDeclaration(name: "charlie", kind: .instanceMethod, line: 1),
            MemberDeclaration(name: "alpha", kind: .instanceMethod, line: 2),
            MemberDeclaration(name: "bravo", kind: .instanceMethod, line: 3),
        ]
        let result = engine.reorder(members)

        #expect(result[0].name == "charlie")
        #expect(result[1].name == "alpha")
        #expect(result[2].name == "bravo")
    }

    @Test("Full structural model order")
    func fullStructuralModelOrder() {
        let members = [
            MemberDeclaration(name: "deinit", kind: .deinitializer, line: 1),
            MemberDeclaration(name: "subscript", kind: .subscriptMember, line: 2),
            MemberDeclaration(name: "instanceMethod", kind: .instanceMethod, line: 3),
            MemberDeclaration(name: "typeMethod", kind: .typeMethod, line: 4),
            MemberDeclaration(name: "subtype", kind: .subtype, line: 5),
            MemberDeclaration(name: "instanceProperty", kind: .instanceProperty, line: 6),
            MemberDeclaration(name: "typeProperty", kind: .typeProperty, line: 7),
            MemberDeclaration(name: "init", kind: .initializer, line: 8),
            MemberDeclaration(name: "associatedtype", kind: .associatedType, line: 9),
            MemberDeclaration(name: "typealias", kind: .typeAlias, line: 10),
        ]
        let result = engine.reorder(members)

        #expect(result[0].kind == MemberKind.typeAlias)
        #expect(result[1].kind == MemberKind.associatedType)
        #expect(result[2].kind == MemberKind.initializer)
        #expect(result[3].kind == MemberKind.typeProperty)
        #expect(result[4].kind == MemberKind.instanceProperty)
        #expect(result[5].kind == MemberKind.subtype)
        #expect(result[6].kind == MemberKind.typeMethod)
        #expect(result[7].kind == MemberKind.instanceMethod)
        #expect(result[8].kind == MemberKind.subscriptMember)
        #expect(result[9].kind == MemberKind.deinitializer)
    }
}
