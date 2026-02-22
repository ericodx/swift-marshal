import SwiftSyntax

protocol MemberOutputBuilder: Sendable {

    // MARK: - Associated Types

    associatedtype Output: Sendable

    // MARK: - Methods

    func build(from info: MemberDiscoveryInfo, using converter: SourceLocationConverter) -> Output
}
