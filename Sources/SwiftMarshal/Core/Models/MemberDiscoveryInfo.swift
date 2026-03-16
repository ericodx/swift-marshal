import SwiftSyntax

struct MemberDiscoveryInfo: Sendable {
    let name: String
    let kind: MemberKind
    let position: AbsolutePosition
    let item: MemberBlockItemSyntax
    let visibility: Visibility
    let isAnnotated: Bool
}
