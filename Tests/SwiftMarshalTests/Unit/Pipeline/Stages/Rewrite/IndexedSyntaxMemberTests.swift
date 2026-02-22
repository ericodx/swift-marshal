import Testing

@testable import swift_marshal

@Suite("IndexedSyntaxMember Tests")
struct IndexedSyntaxMemberTests {

    // MARK: - Tests

    @Test("Given a SyntaxMemberDeclaration and index, when creating IndexedSyntaxMember, then stores both values")
    func storesMemberAndIndex() {
        let member = makeSyntaxMember(name: "test", kind: .instanceProperty)
        let indexed = IndexedSyntaxMember(member: member, originalIndex: 5)

        #expect(indexed.member.declaration.name == "test")
        #expect(indexed.originalIndex == 5)
    }

    @Test("Given IndexedSyntaxMember, when stored as Sendable, then can be recovered")
    func isSendable() {
        let member = makeSyntaxMember(name: "prop", kind: .instanceProperty)
        let indexed = IndexedSyntaxMember(member: member, originalIndex: 3)
        let sendable: any Sendable = indexed

        #expect((sendable as? IndexedSyntaxMember)?.originalIndex == 3)
    }

    @Test("Given multiple IndexedSyntaxMembers, when comparing indices, then each has distinct original index")
    func maintainsDistinctIndices() {
        let members = makeSyntaxMembers(names: ["a", "b", "c"])
        let indexed = makeIndexedMembers(from: members)

        #expect(indexed[0].originalIndex == 0)
        #expect(indexed[1].originalIndex == 1)
        #expect(indexed[2].originalIndex == 2)
    }
}
