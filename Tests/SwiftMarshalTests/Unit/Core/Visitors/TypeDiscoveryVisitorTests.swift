import Testing

@testable import swift_marshal

@Suite("TypeDiscoveryVisitor Tests")
struct TypeDiscoveryVisitorTests {

    // MARK: - Tests

    @Test("Given a struct declaration source, when discovering types with TypeDiscoveryVisitor, then discovers struct")
    func discoversStruct() {
        let declarations = discoverTypes(in: "struct Foo {}")

        #expect(declarations.count == 1)
        #expect(declarations[0].name == "Foo")
        #expect(declarations[0].kind == .structType)
    }

    @Test("Given a class declaration source, when discovering types with TypeDiscoveryVisitor, then discovers class")
    func discoversClass() {
        let declarations = discoverTypes(in: "class Bar {}")

        #expect(declarations.count == 1)
        #expect(declarations[0].name == "Bar")
        #expect(declarations[0].kind == .classType)
    }

    @Test("Given an enum declaration source, when discovering types with TypeDiscoveryVisitor, then discovers enum")
    func discoversEnum() {
        let declarations = discoverTypes(in: "enum Status { case active }")

        #expect(declarations.count == 1)
        #expect(declarations[0].name == "Status")
        #expect(declarations[0].kind == .enumType)
    }

    @Test("Given an actor declaration source, when discovering types with TypeDiscoveryVisitor, then discovers actor")
    func discoversActor() {
        let declarations = discoverTypes(in: "actor Worker {}")

        #expect(declarations.count == 1)
        #expect(declarations[0].name == "Worker")
        #expect(declarations[0].kind == .actorType)
    }

    @Test(
        "Given a protocol declaration source, when discovering types with TypeDiscoveryVisitor, then discovers protocol"
    )
    func discoversProtocol() {
        let declarations = discoverTypes(in: "protocol Runnable {}")

        #expect(declarations.count == 1)
        #expect(declarations[0].name == "Runnable")
        #expect(declarations[0].kind == .protocolType)
    }

    @Test(
        "Given nested type declarations in source, when discovering types with TypeDiscoveryVisitor, then discovers nested types"
    )
    func discoversNestedTypes() {
        let source = """
            struct Outer {
                class Inner {}
            }
            """
        let declarations = discoverTypes(in: source)

        #expect(declarations.count == 2)
        #expect(declarations[0].name == "Outer")
        #expect(declarations[1].name == "Inner")
    }

    @Test(
        "Given multiple type declarations in source, when discovering types with TypeDiscoveryVisitor, then records correct line numbers"
    )
    func recordsLineNumbers() {
        let source = """
            struct First {}

            struct Second {}
            """
        let declarations = discoverTypes(in: source)

        #expect(declarations[0].line == 1)
        #expect(declarations[1].line == 3)
    }

    @Test(
        "Given source with non-type declarations, when discovering types with TypeDiscoveryVisitor, then ignores non-type declarations"
    )
    func ignoresNonTypes() {
        let source = """
            let x = 1
            func foo() {}
            var y = 2
            """
        let declarations = discoverTypes(in: source)

        #expect(declarations.isEmpty)
    }

    @Test("Given an empty source file, when discovering types with TypeDiscoveryVisitor, then handles empty source")
    func handlesEmptySource() {
        let declarations = discoverTypes(in: "")
        #expect(declarations.isEmpty)
    }
}
