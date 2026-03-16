import SwiftSyntax

struct ApplyRewriteStage: Stage {

    // MARK: - Stage

    func process(_ input: RewritePlanOutput) throws -> RewriteOutput {
        guard input.needsRewriting else {
            return RewriteOutput(
                path: input.path,
                source: input.syntax.description,
                modified: false
            )
        }

        let rewriter = MemberReorderingRewriter(plans: input.plans)
        let rewrittenSyntax = rewriter.rewrite(input.syntax)

        return RewriteOutput(
            path: input.path,
            source: rewrittenSyntax.description,
            modified: true
        )
    }
}
