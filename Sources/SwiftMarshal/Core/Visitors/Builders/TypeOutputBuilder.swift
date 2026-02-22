import SwiftSyntax

protocol TypeOutputBuilder: Sendable {

    // MARK: - Associated Types

    associatedtype MemberBuilder: MemberOutputBuilder
    associatedtype Output: Sendable

    // MARK: - Properties

    var memberBuilder: MemberBuilder { get }

    // MARK: - Methods

    func build(from info: TypeDiscoveryInfo<MemberBuilder.Output>, using converter: SourceLocationConverter) -> Output
}
