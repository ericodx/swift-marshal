import SwiftParser
import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("TypeRewritePlan Tests")
struct TypeRewritePlanTests {

    @Test("Given TypeRewritePlan, when accessing typeName, then returns correct name")
    func accessesTypeName() {
        let plan = makeTypeRewritePlan(typeName: "MyClass")

        #expect(plan.typeName == "MyClass")
    }

    @Test("Given TypeRewritePlan, when accessing kind, then returns correct kind")
    func accessesKind() {
        let plan = makeTypeRewritePlan(kind: .enumType)

        #expect(plan.kind == .enumType)
    }

    @Test("Given TypeRewritePlan, when accessing line, then returns correct line")
    func accessesLine() {
        let plan = makeTypeRewritePlan(line: 15)

        #expect(plan.line == 15)
    }

    @Test("Given TypeRewritePlan, when accessing originalMembers, then returns original members")
    func accessesOriginalMembers() {
        let members = makeSyntaxMembers(names: ["x", "y"])
        let plan = makeTypeRewritePlan(originalMembers: members)

        #expect(plan.originalMembers.count == 2)
    }

    @Test("Given TypeRewritePlan, when accessing reorderedMembers, then returns reordered members")
    func accessesReorderedMembers() {
        let members = makeSyntaxMembers(names: ["a", "b"])
        let indexed = makeIndexedMembers(from: members)
        let plan = makeTypeRewritePlan(originalMembers: members, reorderedMembers: indexed)

        #expect(plan.reorderedMembers.count == 2)
    }

    // MARK: - needsRewriting

    @Test("Given TypeRewritePlan with same order, when checking needsRewriting, then returns false")
    func needsRewritingFalseWhenSameOrder() {
        let members = makeSyntaxMembers(names: ["x"], kinds: [.instanceProperty])
        let indexed = makeIndexedMembers(from: members)
        let plan = makeTypeRewritePlan(originalMembers: members, reorderedMembers: indexed)

        #expect(plan.needsRewriting == false)
    }

    @Test("Given TypeRewritePlan with different order, when checking needsRewriting, then returns true")
    func needsRewritingTrueWhenDifferentOrder() {
        let original = makeSyntaxMembers(names: ["method", "init"], kinds: [.instanceMethod, .initializer])
        let reordered = makeReorderedIndexedMembers(from: original, reorderedIndices: [1, 0])
        let plan = makeTypeRewritePlan(originalMembers: original, reorderedMembers: reordered)

        #expect(plan.needsRewriting == true)
    }

    @Test("Given TypeRewritePlan with empty members, when checking needsRewriting, then returns false")
    func needsRewritingFalseWhenEmpty() {
        let plan = makeTypeRewritePlan(originalMembers: [], reorderedMembers: [])

        #expect(plan.needsRewriting == false)
    }
}
