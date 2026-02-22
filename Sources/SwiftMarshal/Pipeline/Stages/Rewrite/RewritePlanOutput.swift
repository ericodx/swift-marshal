import SwiftSyntax

struct RewritePlanOutput: Sendable {

    // MARK: - Properties

    let path: String
    let syntax: SourceFileSyntax
    let plans: [TypeRewritePlan]

    // MARK: - Computed Properties

    var needsRewriting: Bool {
        plans.contains { $0.needsRewriting }
    }
}
