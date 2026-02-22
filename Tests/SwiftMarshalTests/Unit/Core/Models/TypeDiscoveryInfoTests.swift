import SwiftParser
import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("TypeDiscoveryInfo Tests")
struct TypeDiscoveryInfoTests {

    // MARK: - Tests

    @Test("Given TypeDiscoveryInfo, when accessing name, then returns correct name")
    func accessesName() {
        let info = makeTypeDiscoveryInfo(name: "MyType")

        #expect(info.name == "MyType")
    }

    @Test("Given TypeDiscoveryInfo, when accessing kind, then returns correct kind")
    func accessesKind() {
        let info = makeTypeDiscoveryInfo(kind: .classType)

        #expect(info.kind == .classType)
    }

    @Test("Given TypeDiscoveryInfo with struct kind, when accessing kind, then returns struct")
    func accessesStructKind() {
        let info = makeTypeDiscoveryInfo(kind: .structType)

        #expect(info.kind == .structType)
    }

    @Test("Given TypeDiscoveryInfo with enum kind, when accessing kind, then returns enum")
    func accessesEnumKind() {
        let info = makeTypeDiscoveryInfo(kind: .enumType)

        #expect(info.kind == .enumType)
    }

    @Test("Given TypeDiscoveryInfo, when accessing position, then returns valid position")
    func accessesPosition() {
        let info = makeTypeDiscoveryInfo()

        #expect(info.position.utf8Offset >= 0)
    }

    @Test("Given TypeDiscoveryInfo with members, when accessing members, then returns members")
    func accessesMembers() {
        let members = [
            MemberDeclaration(name: "x", kind: .instanceProperty, line: 2),
            MemberDeclaration(name: "y", kind: .instanceMethod, line: 3),
        ]
        let info = makeTypeDiscoveryInfo(members: members)

        #expect(info.members.count == 2)
        #expect(info.members[0].name == "x")
        #expect(info.members[1].name == "y")
    }

    @Test("Given TypeDiscoveryInfo with no members, when accessing members, then returns empty array")
    func accessesEmptyMembers() {
        let info = makeTypeDiscoveryInfo(members: [])

        #expect(info.members.isEmpty)
    }

    @Test("Given TypeDiscoveryInfo, when accessing memberBlock, then returns syntax")
    func accessesMemberBlock() {
        let info = makeTypeDiscoveryInfo()

        #expect(info.memberBlock.members.count >= 0)
    }
}
