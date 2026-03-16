import SwiftParser
import SwiftSyntax
import Testing

@testable import swift_marshal

@Suite("SyntaxMemberDeclarationBuilder Tests")
struct SyntaxMemberDeclarationBuilderTests {

    // MARK: - Properties

    let builder = SyntaxMemberDeclarationBuilder()

    // MARK: - Tests

    @Test("Given member info, when building, then creates SyntaxMemberDeclaration with correct name")
    func createsWithCorrectName() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(name: "testMethod", kind: .instanceMethod)

        let result = builder.build(from: info, using: converter)

        #expect(result.declaration.name == "testMethod")
    }

    @Test("Given member info, when building, then creates SyntaxMemberDeclaration with correct kind")
    func createsWithCorrectKind() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(name: "testMethod", kind: .instanceMethod)

        let result = builder.build(from: info, using: converter)

        #expect(result.declaration.kind == .instanceMethod)
    }

    @Test("Given member info, when building, then creates SyntaxMemberDeclaration with syntax reference")
    func createsWithSyntaxReference() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(name: "test", kind: .instanceProperty)

        let result = builder.build(from: info, using: converter)

        #expect(result.syntax == info.item)
    }

    @Test("Given member info with visibility, when building, then preserves visibility in declaration")
    func preservesVisibility() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(
            name: "test", kind: .instanceProperty, visibility: .publicAccess)

        let result = builder.build(from: info, using: converter)

        #expect(result.declaration.visibility == .publicAccess)
    }

    @Test("Given annotated member info, when building, then preserves annotated flag")
    func preservesAnnotatedFlag() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(
            name: "test", kind: .instanceProperty, isAnnotated: true)

        let result = builder.build(from: info, using: converter)

        #expect(result.declaration.isAnnotated == true)
    }

    @Test("Given member info, when building, then creates SyntaxMemberDeclaration with correct line")
    func createsWithCorrectLine() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(name: "test", kind: .instanceProperty)

        let result = builder.build(from: info, using: converter)

        #expect(result.declaration.line >= 1)
    }
}
