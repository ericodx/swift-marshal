import SwiftParser
import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("TypeDeclarationBuilder Tests")
struct TypeDeclarationBuilderTests {

    // MARK: - Properties

    let builder = TypeDeclarationBuilder()

    // MARK: - Tests

    @Test("Given type info, when building, then creates TypeDeclaration with correct name")
    func createsWithCorrectName() {
        let (info, converter) = makeTypeDiscoveryInfoWithConverter(name: "MyStruct", kind: .structType)

        let result = builder.build(from: info, using: converter)

        #expect(result.name == "MyStruct")
    }

    @Test("Given type info, when building, then creates TypeDeclaration with correct kind")
    func createsWithCorrectKind() {
        let (info, converter) = makeTypeDiscoveryInfoWithConverter(name: "MyClass", kind: .classType)

        let result = builder.build(from: info, using: converter)

        #expect(result.kind == .classType)
    }

    @Test("Given type info with members, when building, then creates TypeDeclaration with members")
    func createsWithMembers() {
        let members = [
            MemberDeclaration(name: "property", kind: .instanceProperty, line: 2),
            MemberDeclaration(name: "method", kind: .instanceMethod, line: 3),
        ]
        let (info, converter) = makeTypeDiscoveryInfoWithConverter(name: "Test", kind: .structType, members: members)

        let result = builder.build(from: info, using: converter)

        #expect(result.members.count == 2)
        #expect(result.members[0].name == "property")
        #expect(result.members[1].name == "method")
    }

    @Test("Given type info, when building, then creates TypeDeclaration with correct line")
    func createsWithCorrectLine() {
        let (info, converter) = makeTypeDiscoveryInfoWithConverter(name: "Test", kind: .structType)

        let result = builder.build(from: info, using: converter)

        #expect(result.line >= 1)
    }

    @Test("Given enum type info, when building, then creates TypeDeclaration with enum kind")
    func createsEnumKind() {
        let (info, converter) = makeTypeDiscoveryInfoWithConverter(name: "MyEnum", kind: .enumType)

        let result = builder.build(from: info, using: converter)

        #expect(result.kind == .enumType)
    }

    @Test("Given type info with empty members, when building, then creates TypeDeclaration with empty members")
    func createsWithEmptyMembers() {
        let (info, converter) = makeTypeDiscoveryInfoWithConverter(name: "Empty", kind: .structType, members: [])

        let result = builder.build(from: info, using: converter)

        #expect(result.members.isEmpty)
    }
}
