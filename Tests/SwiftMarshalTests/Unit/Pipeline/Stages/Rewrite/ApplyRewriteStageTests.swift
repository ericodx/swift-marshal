import SwiftParser
import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("ApplyRewriteStage Tests")
struct ApplyRewriteStageTests {

    let stage = ApplyRewriteStage()

    // MARK: - No Rewriting Needed

    @Test("Given input that needs no rewriting, when processing, then returns unmodified source")
    func returnsUnmodifiedSource() throws {
        let source = """
            struct Test {
                init() {}
                func doSomething() {}
            }
            """
        let syntax = Parser.parse(source: source)
        let input = RewritePlanOutput(path: "Test.swift", syntax: syntax, plans: [])

        let output = try stage.process(input)

        #expect(output.modified == false)
        #expect(output.source == syntax.description)
    }

    @Test("Given input with no plans, when processing, then modified is false")
    func modifiedIsFalseWithNoPlans() throws {
        let source = "struct Empty {}"
        let syntax = Parser.parse(source: source)
        let input = RewritePlanOutput(path: "Test.swift", syntax: syntax, plans: [])

        let output = try stage.process(input)

        #expect(output.modified == false)
    }

    // MARK: - Rewriting Needed

    @Test("Given input that needs rewriting, when processing, then returns modified source")
    func returnsModifiedSource() throws {
        let source = """
            struct Test {
                func doSomething() {}
                init() {}
            }
            """
        let planOutput = try makeRewritePlan(from: source)

        let output = try stage.process(planOutput)

        #expect(output.modified == true)
        #expect(output.source.contains("init()"))
    }

    @Test("Given input that needs rewriting, when processing, then modified is true")
    func modifiedIsTrueWhenRewritten() throws {
        let source = """
            struct Test {
                func doSomething() {}
                init() {}
            }
            """
        let planOutput = try makeRewritePlan(from: source)

        let output = try stage.process(planOutput)

        #expect(output.modified == true)
    }

    // MARK: - Path Preservation

    @Test("Given input with path, when processing, then output preserves path")
    func preservesPath() throws {
        let source = "struct Test {}"
        let syntax = Parser.parse(source: source)
        let input = RewritePlanOutput(path: "MyFile.swift", syntax: syntax, plans: [])

        let output = try stage.process(input)

        #expect(output.path == "MyFile.swift")
    }
}
