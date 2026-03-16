import SwiftSyntax

struct TypeDiscoveryInfo<MemberOutput: Sendable>: Sendable {
    let name: String
    let kind: TypeKind
    let position: AbsolutePosition
    let members: [MemberOutput]
    let memberBlock: MemberBlockSyntax
}
