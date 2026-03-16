import SwiftSyntax

final class MemberReorderingRewriter: SyntaxRewriter {

    // MARK: - Initialization

    init(plans: [TypeRewritePlan]) {
        var byName: [String: [TypeRewritePlan]] = [:]
        for plan in plans where plan.needsRewriting {
            byName[plan.typeName, default: []].append(plan)
        }
        self.plansByName = byName
        super.init()
    }

    // MARK: - Properties

    private let plansByName: [String: [TypeRewritePlan]]

    // MARK: - Type Visitors

    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        super.visit(
            applyingReorder(to: node, name: node.name.text, memberBlock: node.memberBlock) {
                $0.with(\.memberBlock, $1)
            })
    }

    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        super.visit(
            applyingReorder(to: node, name: node.name.text, memberBlock: node.memberBlock) {
                $0.with(\.memberBlock, $1)
            })
    }

    override func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
        super.visit(
            applyingReorder(to: node, name: node.name.text, memberBlock: node.memberBlock) {
                $0.with(\.memberBlock, $1)
            })
    }

    override func visit(_ node: ActorDeclSyntax) -> DeclSyntax {
        super.visit(
            applyingReorder(to: node, name: node.name.text, memberBlock: node.memberBlock) {
                $0.with(\.memberBlock, $1)
            })
    }

    override func visit(_ node: ProtocolDeclSyntax) -> DeclSyntax {
        super.visit(
            applyingReorder(to: node, name: node.name.text, memberBlock: node.memberBlock) {
                $0.with(\.memberBlock, $1)
            })
    }

    private func applyingReorder<Node>(
        to node: Node,
        name: String,
        memberBlock: MemberBlockSyntax,
        applying: (Node, MemberBlockSyntax) -> Node
    ) -> Node {
        guard let plan = findPlan(for: name, memberBlock: memberBlock) else {
            return node
        }

        return applying(node, reorderMemberBlock(memberBlock, using: plan))
    }

    // MARK: - Plan Matching

    private func findPlan(for name: String, memberBlock: MemberBlockSyntax) -> TypeRewritePlan? {
        guard let candidates = plansByName[name] else { return nil }

        for plan in candidates where membersMatchByID(memberBlock: memberBlock, plan: plan) {
            return plan
        }
        for plan in candidates where membersMatchByCount(memberBlock: memberBlock, plan: plan) {
            return plan
        }
        return nil
    }

    private func membersMatchByID(memberBlock: MemberBlockSyntax, plan: TypeRewritePlan) -> Bool {
        let planMemberIDs = Set(plan.originalMembers.map(\.syntax.id))
        let trackedBlockMembers = Array(memberBlock.members).filter { planMemberIDs.contains($0.id) }

        guard trackedBlockMembers.count == plan.originalMembers.count else { return false }

        return zip(trackedBlockMembers, plan.originalMembers.map(\.syntax)).allSatisfy { $0.id == $1.id }
    }

    private func membersMatchByCount(memberBlock: MemberBlockSyntax, plan: TypeRewritePlan) -> Bool {
        return memberBlock.members.count == plan.originalMembers.count
    }

    // MARK: - Member Reordering

    private func reorderMemberBlock(
        _ memberBlock: MemberBlockSyntax,
        using plan: TypeRewritePlan
    ) -> MemberBlockSyntax {
        guard !plan.reorderedMembers.isEmpty else { return memberBlock }

        let allItems = Array(memberBlock.members)
        let trackedIDs = Set(plan.originalMembers.map(\.syntax.id))

        var trackedIndices: [Int] = []
        let idMatches = allItems.enumerated().filter { trackedIDs.contains($0.element.id) }

        if idMatches.count == plan.originalMembers.count {
            trackedIndices = idMatches.map(\.offset)
        } else {
            trackedIndices = Array(0 ..< allItems.count)
        }

        let firstTrackedIndex = trackedIndices[0]
        let originalFirstTrackedTrivia = allItems[firstTrackedIndex].leadingTrivia

        var reorderedTrackedItems: [MemberBlockItemSyntax] = []
        for (newIndex, indexedMember) in plan.reorderedMembers.enumerated() {
            let originalIndex = indexedMember.originalIndex
            var item = allItems[trackedIndices[originalIndex]]

            if newIndex == 0 {
                let trivia =
                    originalIndex != 0
                    ? ensureBlankLine(in: originalFirstTrackedTrivia)
                    : originalFirstTrackedTrivia
                item = item.with(\.leadingTrivia, trivia)
            } else if originalIndex == 0 {
                let trivia = inferLeadingTriviaFromItems(allItems, trackedIndices: trackedIndices)
                item = item.with(\.leadingTrivia, ensureBlankLine(in: trivia))
            } else {
                let previousOriginalIndex = plan.reorderedMembers[newIndex - 1].originalIndex
                if originalIndex != previousOriginalIndex + 1 {
                    item = item.with(\.leadingTrivia, ensureBlankLine(in: item.leadingTrivia))
                }
            }

            reorderedTrackedItems.append(item)
        }

        var finalItems: [MemberBlockItemSyntax] = []
        var reorderedIndex = 0

        for (index, item) in allItems.enumerated() {
            if trackedIndices.contains(index) {
                finalItems.append(reorderedTrackedItems[reorderedIndex])
                reorderedIndex += 1
            } else {
                finalItems.append(item)
            }
        }

        let newMembers = MemberBlockItemListSyntax(finalItems)
        return memberBlock.with(\.members, newMembers)
    }

    private func inferLeadingTriviaFromItems(_ items: [MemberBlockItemSyntax], trackedIndices: [Int]) -> Trivia {
        return items[trackedIndices[1]].leadingTrivia
    }

    private func ensureBlankLine(in trivia: Trivia) -> Trivia {
        var pieces = Array(trivia)
        guard let first = pieces.first, case .newlines(let count) = first, count < 2 else {
            return trivia
        }
        pieces[0] = .newlines(2)
        return Trivia(pieces: pieces)
    }
}
