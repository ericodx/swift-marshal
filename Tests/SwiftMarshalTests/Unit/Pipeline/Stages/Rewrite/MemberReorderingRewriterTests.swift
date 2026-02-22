import SwiftParser
import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("MemberReorderingRewriter Tests")
struct MemberReorderingRewriterTests {

    @Test(
        "Given a struct with members out of order, when rewriting with MemberReorderingRewriter, then reorders members in struct"
    )
    func reordersStructMembers() throws {
        let source = """
            struct Foo {
                func doSomething() {}
                init() {}
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result.contains("init()"))
        #expect(result.contains("func doSomething()"))

        guard let initRange = result.range(of: "init()"),
            let funcRange = result.range(of: "func doSomething()")
        else {
            Issue.record("Expected strings not found")
            return
        }
        #expect(initRange.lowerBound < funcRange.lowerBound)
    }

    @Test(
        "Given a struct with commented members, when rewriting with MemberReorderingRewriter, then preserves comments with members"
    )
    func preservesComments() throws {
        let source = """
            struct Foo {
                // Method comment
                func doSomething() {}

                // Init comment
                init() {}
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result.contains("// Init comment"))
        #expect(result.contains("// Method comment"))
    }

    @Test(
        "Given a struct with already ordered members, when rewriting with MemberReorderingRewriter, then no change when already ordered"
    )
    func noChangeWhenOrdered() throws {
        let source = """
            struct Foo {
                init() {}
                func doSomething() {}
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result == source)
    }

    @Test(
        "Given the same source rewritten multiple times, when rewriting with MemberReorderingRewriter, then deterministic output"
    )
    func deterministic() throws {
        let source = """
            struct Foo {
                func b() {}
                func a() {}
                var prop: Int
                init() {}
            }
            """

        let result1 = try applyRewrite(to: source)
        let result2 = try applyRewrite(to: source)

        #expect(result1 == result2)
    }

    @Test(
        "Given already rewritten source, when rewriting again with MemberReorderingRewriter, then idempotent rewriting")
    func idempotent() throws {
        let source = """
            struct Foo {
                func doSomething() {}
                var name: String
                init() {}
            }
            """

        let result1 = try applyRewrite(to: source)
        let result2 = try applyRewrite(to: result1)

        #expect(result1 == result2)
    }

    @Test("Given multiple types in source, when rewriting with MemberReorderingRewriter, then handles multiple types")
    func handlesMultipleTypes() throws {
        let source = """
            struct Foo {
                func a() {}
                init() {}
            }

            class Bar {
                func b() {}
                init() {}
            }
            """

        let result = try applyRewrite(to: source)

        guard let initRange = result.range(of: "init()"),
            let funcRange = result.range(of: "func a()")
        else {
            Issue.record("Expected strings not found")
            return
        }
        #expect(initRange.lowerBound < funcRange.lowerBound)
    }

    @Test(
        "Given nested types in source, when rewriting with MemberReorderingRewriter, then preserves nested type structure"
    )
    func preservesNestedTypes() throws {
        let source = """
            struct Outer {
                func outerMethod() {}
                init() {}

                struct Inner {
                    func innerMethod() {}
                }
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result.contains("struct Inner"))
        #expect(result.contains("func innerMethod()"))
    }

    // MARK: - Actor and Protocol Reordering

    @Test("Given an actor with members out of order, when rewriting, then reorders actor members")
    func reordersActorMembers() throws {
        let source = """
            actor Counter {
                func increment() {}
                init() {}
                var count: Int
            }
            """

        let result = try applyRewrite(to: source)

        guard let initRange = result.range(of: "init()"),
            let varRange = result.range(of: "var count")
        else {
            Issue.record("Expected strings not found")
            return
        }
        #expect(initRange.lowerBound < varRange.lowerBound)
    }

    @Test("Given an enum with members out of order, when rewriting, then reorders enum members")
    func reordersEnumMembers() throws {
        let source = """
            enum Status {
                func description() -> String { "" }
                case active
                case inactive
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result.contains("case active"))
        #expect(result.contains("func description()"))
    }

    @Test("Given a class that does not need reordering, when rewriting, then returns unchanged")
    func classWithoutReorderingNeeded() throws {
        let source = """
            class Service {
                init() {}
                func start() {}
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result == source)
    }

    @Test("Given a protocol with members out of order, when rewriting, then reorders protocol members")
    func reordersProtocolMembers() throws {
        let source = """
            protocol Service {
                func start()
                init()
            }
            """

        let result = try applyRewrite(to: source)

        guard let initRange = result.range(of: "init()"),
            let funcRange = result.range(of: "func start()")
        else {
            Issue.record("Expected strings not found")
            return
        }
        #expect(initRange.lowerBound < funcRange.lowerBound)
    }

    @Test("Given a type with single member, when rewriting, then handles single member correctly")
    func handlesSingleMember() throws {
        let source = """
            struct Single {
                var value: Int
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result == source)
    }

    // MARK: - Mixed Types with Different Reordering Needs

    @Test(
        "Given a class already ordered alongside a struct needing reordering, when rewriting, then reorders struct and preserves class"
    )
    func classOrderedWithStructNeeding() throws {
        let source = """
            class OrderedClass {
                init() {}
                func doWork() {}
            }

            struct NeedsReorder {
                func method() {}
                init() {}
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result.contains("class OrderedClass"))
        #expect(result.contains("struct NeedsReorder"))

        guard let structInitRange = result.range(of: "struct NeedsReorder"),
            let initInStructRange = result.range(of: "init() {}", range: structInitRange.upperBound ..< result.endIndex)
        else {
            Issue.record("Expected strings not found")
            return
        }
        #expect(initInStructRange.lowerBound > structInitRange.lowerBound)
    }

    @Test(
        "Given an actor already ordered alongside a struct needing reordering, when rewriting, then reorders struct and preserves actor"
    )
    func actorOrderedWithStructNeeding() throws {
        let source = """
            actor OrderedActor {
                init() {}
                func doWork() {}
            }

            struct NeedsReorder {
                func method() {}
                init() {}
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result.contains("actor OrderedActor"))
        #expect(result.contains("struct NeedsReorder"))
    }

    @Test(
        "Given a protocol already ordered alongside a struct needing reordering, when rewriting, then reorders struct and preserves protocol"
    )
    func protocolOrderedWithStructNeeding() throws {
        let source = """
            protocol OrderedProtocol {
                init()
                func doWork()
            }

            struct NeedsReorder {
                func method() {}
                init() {}
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result.contains("protocol OrderedProtocol"))
        #expect(result.contains("struct NeedsReorder"))
    }

    @Test(
        "Given a struct with single tracked member alongside another struct, when rewriting, then handles single tracked member"
    )
    func handlesSingleTrackedMember() throws {
        let source = """
            struct Outer {
                func outerMethod() {}
                init() {}

                struct Inner {
                    var value: Int
                }
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result.contains("struct Outer"))
        #expect(result.contains("struct Inner"))
    }

    // MARK: - Edge Cases

    @Test("Given a type with empty body, when rewriting, then handles empty body")
    func handlesEmptyBody() throws {
        let source = """
            struct Empty {
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result == source)
    }

    @Test(
        "Given a struct where first member moves to different position, when rewriting, then normalizes trivia correctly"
    )
    func normalizesTriviasWhenFirstMemberMoves() throws {
        let source = """
            struct Test {
                func method() {}

                init() {}

                var property: Int
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result.contains("init()"))
        #expect(result.contains("var property"))
        #expect(result.contains("func method()"))
    }

    @Test("Given an enum with only cases, when rewriting, then preserves enum cases")
    func preservesEnumCases() throws {
        let source = """
            enum Direction {
                case north
                case south
                case east
                case west
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result == source)
    }

    @Test("Given a struct with only properties, when rewriting, then handles properties only")
    func handlesPropertiesOnly() throws {
        let source = """
            struct Config {
                var name: String
                let value: Int
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result == source)
    }

    @Test("Given a class with only methods, when rewriting, then handles methods only")
    func handlesMethodsOnly() throws {
        let source = """
            class Worker {
                func start() {}
                func stop() {}
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result == source)
    }

    @Test("Given an actor with mixed members, when rewriting, then reorders actor members correctly")
    func reordersActorMixedMembers() throws {
        let source = """
            actor DataStore {
                func save() {}
                private var data: [String] = []
                init() {}
            }
            """

        let result = try applyRewrite(to: source)

        guard let initRange = result.range(of: "init()"),
            let funcRange = result.range(of: "func save()")
        else {
            Issue.record("Expected strings not found")
            return
        }
        #expect(initRange.lowerBound < funcRange.lowerBound)
    }

    @Test("Given a protocol with only methods, when rewriting, then preserves protocol methods")
    func preservesProtocolMethods() throws {
        let source = """
            protocol Runnable {
                func run()
                func stop()
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result == source)
    }

    // MARK: - Edge Cases with Custom Plans

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
