import SwiftParser
import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("MemberDiscoveryInfo Tests")
struct MemberDiscoveryInfoTests {

    @Test("Given MemberDiscoveryInfo, when accessing name, then returns correct name")
    func accessesName() {
        let info = makeMemberDiscoveryInfo(name: "myProperty")

        #expect(info.name == "myProperty")
    }

    @Test("Given MemberDiscoveryInfo, when accessing kind, then returns correct kind")
    func accessesKind() {
        let info = makeMemberDiscoveryInfo(kind: .instanceMethod)

        #expect(info.kind == .instanceMethod)
    }

    @Test("Given MemberDiscoveryInfo, when accessing visibility, then returns correct visibility")
    func accessesVisibility() {
        let info = makeMemberDiscoveryInfo(visibility: .privateAccess)

        #expect(info.visibility == .privateAccess)
    }

    @Test("Given MemberDiscoveryInfo, when accessing isAnnotated, then returns correct value")
    func accessesIsAnnotated() {
        let info = makeMemberDiscoveryInfo(isAnnotated: true)

        #expect(info.isAnnotated == true)
    }

    @Test("Given MemberDiscoveryInfo with default values, when accessing isAnnotated, then returns false")
    func defaultIsAnnotated() {
        let info = makeMemberDiscoveryInfo()

        #expect(info.isAnnotated == false)
    }

    @Test("Given MemberDiscoveryInfo, when accessing position, then returns valid position")
    func accessesPosition() {
        let info = makeMemberDiscoveryInfo()

        #expect(info.position.utf8Offset >= 0)
    }

    @Test("Given MemberDiscoveryInfo, when accessing item, then returns syntax item")
    func accessesItem() {
        let info = makeMemberDiscoveryInfo()

        #expect(info.item.description.contains("var"))
    }

    // MARK: - Sendable

    @Test("Given MemberDiscoveryInfo, when stored as Sendable, then can be recovered with same name")
    func isSendable() {
        let original = makeMemberDiscoveryInfo(name: "testMember")
        let sendable: any Sendable = original

        #expect((sendable as? MemberDiscoveryInfo)?.name == "testMember")
    }
}
