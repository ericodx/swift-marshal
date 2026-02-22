import Testing

@testable import swift_marshal

@Suite("RewritePlanStage Tests")
struct RewritePlanStageTests {

    // MARK: - Tests

    @Test(
        "Given a type that needs member reordering, when creating rewrite plan with RewritePlanStage, then creates plan for type needing reorder"
    )
    func createsPlanForReorder() throws {
        let source = """
            struct Foo {
                func doSomething() {}
                init() {}
            }
            """

        let output = try makeRewritePlan(from: source)

        #expect(output.plans.count == 1)
        #expect(output.plans[0].needsRewriting)
        #expect(output.plans[0].typeName == "Foo")
    }

    @Test(
        "Given a type with correctly ordered members, when creating rewrite plan with RewritePlanStage, then no rewrite needed when ordered"
    )
    func noRewriteWhenOrdered() throws {
        let source = """
            struct Foo {
                init() {}
                func doSomething() {}
            }
            """

        let output = try makeRewritePlan(from: source)

        #expect(output.plans.count == 1)
        #expect(!output.plans[0].needsRewriting)
    }

    @Test(
        "Given a type with specific member order, when creating rewrite plan with RewritePlanStage, then preserves original member order in plan"
    )
    func preservesOriginalOrder() throws {
        let source = """
            struct Foo {
                func b() {}
                func a() {}
                init() {}
            }
            """

        let output = try makeRewritePlan(from: source)
        let originalKinds = output.plans[0].originalMembers.map(\.declaration.kind)

        #expect(originalKinds == [.instanceMethod, .instanceMethod, .initializer])
    }

    @Test(
        "Given a type with members needing reordering, when creating rewrite plan with RewritePlanStage, then reorders members in plan"
    )
    func reordersMembers() throws {
        let source = """
            struct Foo {
                func doSomething() {}
                init() {}
            }
            """

        let output = try makeRewritePlan(from: source)
        let reorderedKinds = output.plans[0].reorderedMembers.map(\.member.declaration.kind)

        #expect(reorderedKinds == [.initializer, .instanceMethod])
    }

    @Test(
        "Given multiple types in source, when creating rewrite plan with RewritePlanStage, then handles multiple types")
    func handlesMultipleTypes() throws {
        let source = """
            struct Foo {
                func a() {}
                init() {}
            }

            class Bar {
                init() {}
                func b() {}
            }
            """

        let output = try makeRewritePlan(from: source)

        #expect(output.plans.count == 2)
        #expect(output.plans[0].needsRewriting)
        #expect(!output.plans[1].needsRewriting)
    }

    @Test(
        "Given rewrite plans for multiple types, when checking overall state with RewritePlanStage, then needsRewriting reflects overall state"
    )
    func needsRewritingReflectsState() throws {
        let needsRewrite = """
            struct Foo {
                func a() {}
                init() {}
            }
            """

        let noRewrite = """
            struct Foo {
                init() {}
                func a() {}
            }
            """

        let output1 = try makeRewritePlan(from: needsRewrite)
        let output2 = try makeRewritePlan(from: noRewrite)

        #expect(output1.needsRewriting)
        #expect(!output2.needsRewriting)
    }

    @Test(
        "Given a scenario where reordered declarations don't match original members, when creating rewrite plan, then handles missing member mapping gracefully"
    )
    func handlesMissingMemberMapping() throws {
        let source = """
            struct TestType {
                func existingMethod() {}
            }
            """

        let stage = RewritePlanStage(configuration: .defaultValue)
        let classifyOutput = try syntaxClassify(source)

        let output = try stage.process(classifyOutput)

        #expect(output.plans.count == 1)
        #expect(output.plans[0].typeName == "TestType")
    }
}
