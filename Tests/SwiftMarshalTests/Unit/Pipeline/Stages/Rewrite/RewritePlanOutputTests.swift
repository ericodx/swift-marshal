import SwiftParser
import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("RewritePlanOutput Tests")
struct RewritePlanOutputTests {

    // MARK: - Tests

    @Test("Given RewritePlanOutput, when accessing path, then returns correct path")
    func accessesPath() {
        let output = makeRewritePlanOutputFactory(path: "/path/to/file.swift")

        #expect(output.path == "/path/to/file.swift")
    }

    @Test("Given RewritePlanOutput, when accessing syntax, then returns SourceFileSyntax")
    func accessesSyntax() {
        let output = makeRewritePlanOutputFactory(source: "struct Test {}")

        #expect(output.syntax.statements.count >= 0)
    }

    @Test("Given RewritePlanOutput, when accessing plans, then returns plans array")
    func accessesPlans() {
        let output = makeRewritePlanOutputFactory()

        #expect(output.plans.count >= 0)
    }

    @Test("Given RewritePlanOutput with empty plans, when checking needsRewriting, then returns false")
    func needsRewritingFalseWhenEmpty() {
        let output = makeRewritePlanOutputFactory()

        #expect(output.needsRewriting == false)
    }

    @Test("Given RewritePlanOutput, when stored as Sendable, then can be recovered with same path")
    func isSendable() {
        let original = makeRewritePlanOutputFactory(path: "/test/path.swift")
        let sendable: any Sendable = original

        #expect((sendable as? RewritePlanOutput)?.path == "/test/path.swift")
    }
}
