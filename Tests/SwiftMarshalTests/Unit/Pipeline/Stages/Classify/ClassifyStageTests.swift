import Testing

@testable import swift_marshal

@Suite("ClassifyStage Tests")
struct ClassifyStageTests {

    // MARK: - Tests

    @Test("Given a struct declaration source, when classifying with ClassifyStage, then classifies struct declaration")
    func classifiesStruct() throws {
        let output = try classify("struct Foo {}")

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].kind == .structType)
        #expect(output.declarations[0].name == "Foo")
    }

    @Test("Given a class declaration source, when classifying with ClassifyStage, then classifies class declaration")
    func classifiesClass() throws {
        let output = try classify("class Bar {}")

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].kind == .classType)
        #expect(output.declarations[0].name == "Bar")
    }

    @Test("Given an enum declaration source, when classifying with ClassifyStage, then classifies enum declaration")
    func classifiesEnum() throws {
        let output = try classify("enum Status {}")

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].kind == .enumType)
        #expect(output.declarations[0].name == "Status")
    }

    @Test("Given an actor declaration source, when classifying with ClassifyStage, then classifies actor declaration")
    func classifiesActor() throws {
        let output = try classify("actor Worker {}")

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].kind == .actorType)
        #expect(output.declarations[0].name == "Worker")
    }

    @Test(
        "Given a protocol declaration source, when classifying with ClassifyStage, then classifies protocol declaration"
    )
    func classifiesProtocol() throws {
        let output = try classify("protocol Runnable {}")

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].kind == .protocolType)
        #expect(output.declarations[0].name == "Runnable")
    }

    @Test(
        "Given multiple type declarations in source, when classifying with ClassifyStage, then classifies multiple declarations"
    )
    func classifiesMultiple() throws {
        let source = """
            struct A {}
            class B {}
            enum C {}
            """
        let output = try classify(source)

        #expect(output.declarations.count == 3)
        #expect(output.declarations[0].name == "A")
        #expect(output.declarations[1].name == "B")
        #expect(output.declarations[2].name == "C")
    }

    @Test("Given nested type declarations in source, when classifying with ClassifyStage, then classifies nested types")
    func classifiesNestedTypes() throws {
        let source = """
            struct Outer {
                struct Inner {}
            }
            """
        let output = try classify(source)

        #expect(output.declarations.count == 2)
        #expect(output.declarations[0].name == "Outer")
        #expect(output.declarations[1].name == "Inner")
    }

    @Test(
        "Given a parsed output with specific path, when classifying with ClassifyStage, then preserves path in output")
    func preservesPath() throws {
        let parseOutput = makeParseOutput(source: "struct X {}", path: "/test/path.swift")
        let stage = ClassifyStage()

        let output = try stage.process(parseOutput)

        #expect(output.path == "/test/path.swift")
    }
}
