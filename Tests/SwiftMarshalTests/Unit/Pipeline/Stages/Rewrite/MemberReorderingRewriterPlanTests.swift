import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("MemberReorderingRewriter Plan Tests")
struct MemberReorderingRewriterPlanTests {

    @Test("Given a plan with empty reorderedMembers, when rewriting, then returns unchanged")
    func handlesEmptyReorderedMembers() {
        let source = """
            struct Test {
                func method() {}
                init() {}
            }
            """

        let types = discoverSyntaxTypes(in: source)
        guard let typeDecl = types.first else {
            Issue.record("No type found")
            return
        }

        let emptyPlan = TypeRewritePlan(
            typeName: typeDecl.name,
            kind: typeDecl.kind,
            line: typeDecl.line,
            originalMembers: typeDecl.members,
            reorderedMembers: []
        )

        let result = applyRewriteWithCustomPlan(to: source, plans: [emptyPlan])

        #expect(result == source)
    }

    @Test("Given a plan with mismatched member count, when rewriting, then returns unchanged")
    func handlesMismatchedMemberCount() {
        let source = """
            struct Test {
                func method() {}
                init() {}
                var property: Int
            }
            """

        let types = discoverSyntaxTypes(in: source)
        guard let typeDecl = types.first, typeDecl.members.count >= 2 else {
            Issue.record("Need at least 2 members")
            return
        }

        let partialMembers = Array(typeDecl.members.prefix(1))
        let mismatchedPlan = TypeRewritePlan(
            typeName: typeDecl.name,
            kind: typeDecl.kind,
            line: typeDecl.line,
            originalMembers: partialMembers,
            reorderedMembers: makeIndexedMembers(from: partialMembers)
        )

        let result = applyRewriteWithCustomPlan(to: source, plans: [mismatchedPlan])

        #expect(result == source)
    }

    @Test("Given a plan with single member, when rewriting, then handles single member trivia")
    func handlesSingleMemberPlan() {
        let source = """
            struct Test {
                var property: Int
            }
            """

        let types = discoverSyntaxTypes(in: source)
        guard let typeDecl = types.first, typeDecl.members.count == 1 else {
            Issue.record("Need exactly 1 member")
            return
        }

        let singleMemberPlan = TypeRewritePlan(
            typeName: typeDecl.name,
            kind: typeDecl.kind,
            line: typeDecl.line,
            originalMembers: typeDecl.members,
            reorderedMembers: makeIndexedMembers(from: typeDecl.members)
        )

        let result = applyRewriteWithCustomPlan(to: source, plans: [singleMemberPlan])

        #expect(result.contains("var property"))
    }

    @Test("Given a plan where needsRewriting is false, when rewriting, then skips plan")
    func skipsNonRewritingPlan() {
        let source = """
            struct Test {
                init() {}
                func method() {}
            }
            """

        let types = discoverSyntaxTypes(in: source)
        guard let typeDecl = types.first else {
            Issue.record("No type found")
            return
        }

        let noChangePlan = TypeRewritePlan(
            typeName: typeDecl.name,
            kind: typeDecl.kind,
            line: typeDecl.line,
            originalMembers: typeDecl.members,
            reorderedMembers: makeIndexedMembers(from: typeDecl.members)
        )

        #expect(noChangePlan.needsRewriting == false)

        let result = applyRewriteWithCustomPlan(to: source, plans: [noChangePlan])

        #expect(result == source)
    }

    @Test(
        "Given a plan built from a different parse but with matching member count, when rewriting, then uses count-based fallback and reorders"
    )
    func countBasedFallbackUsedWhenIDsDiffer() {
        let source = """
            struct Test {
                func method() {}
                init() {}
            }
            """

        let types = discoverSyntaxTypes(in: source)
        guard let typeDecl = types.first else {
            Issue.record("No type found")
            return
        }

        let reversedMembers = makeReorderedIndexedMembers(
            from: typeDecl.members,
            reorderedIndices: Array((0 ..< typeDecl.members.count).reversed())
        )
        let plan = TypeRewritePlan(
            typeName: typeDecl.name,
            kind: typeDecl.kind,
            line: typeDecl.line,
            originalMembers: typeDecl.members,
            reorderedMembers: reversedMembers
        )

        #expect(plan.needsRewriting)

        let result = applyRewriteWithCustomPlan(to: source, plans: [plan])

        guard let initRange = result.range(of: "init()"),
            let funcRange = result.range(of: "func method()")
        else {
            Issue.record("Expected strings not found")
            return
        }
        #expect(initRange.lowerBound < funcRange.lowerBound)
    }

    @Test(
        "Given a plan whose member count does not match the target type, when rewriting, then returns the node unchanged"
    )
    func findPlanReturnsNilWhenNeitherIDNorCountMatches() {
        let source = """
            struct Test {
                func method() {}
                init() {}
            }
            """

        let threeMembers = makeSyntaxMembers(names: ["a", "b", "c"])
        let plan = TypeRewritePlan(
            typeName: "Test",
            kind: .structType,
            line: 1,
            originalMembers: threeMembers,
            reorderedMembers: makeReorderedIndexedMembers(from: threeMembers, reorderedIndices: [2, 1, 0])
        )

        #expect(plan.needsRewriting)

        let result = applyRewriteWithCustomPlan(to: source, plans: [plan])

        #expect(result == source)
    }

    @Test("Given multiple plans with one needing rewriting, when rewriting, then applies only needed plan")
    func appliesOnlyNeededPlans() {
        let source = """
            struct First {
                init() {}
                func method() {}
            }
            struct Second {
                func method() {}
                init() {}
            }
            """

        let types = discoverSyntaxTypes(in: source)
        guard types.count == 2 else {
            Issue.record("Expected 2 types")
            return
        }

        let firstType = types[0]
        let secondType = types[1]

        let noChangePlan = TypeRewritePlan(
            typeName: firstType.name,
            kind: firstType.kind,
            line: firstType.line,
            originalMembers: firstType.members,
            reorderedMembers: makeIndexedMembers(from: firstType.members)
        )

        let reversedIndexed = makeReorderedIndexedMembers(
            from: secondType.members,
            reorderedIndices: Array((0 ..< secondType.members.count).reversed())
        )
        let reorderPlan = TypeRewritePlan(
            typeName: secondType.name,
            kind: secondType.kind,
            line: secondType.line,
            originalMembers: secondType.members,
            reorderedMembers: reversedIndexed
        )

        let result = applyRewriteWithCustomPlan(to: source, plans: [noChangePlan, reorderPlan])

        #expect(result.contains("struct First"))
        #expect(result.contains("struct Second"))
    }
}
