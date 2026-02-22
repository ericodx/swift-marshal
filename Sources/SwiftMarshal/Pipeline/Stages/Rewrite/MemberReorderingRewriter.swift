import SwiftSyntax

final class MemberReorderingRewriter: SyntaxRewriter {

    // MARK: - Initialization

    init(plans: [TypeRewritePlan]) {
        var dict: [TypeLocation: TypeRewritePlan] = [:]
        for plan in plans where plan.needsRewriting {
            let location = TypeLocation(name: plan.typeName, line: plan.line)
            dict[location] = plan
        }
        self.plansByLocation = dict
        super.init()
    }

    // MARK: - Properties

    private let plansByLocation: [TypeLocation: TypeRewritePlan]

    // MARK: - Type Visitors

    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        guard let plan = findPlan(for: node.name.text, memberBlock: node.memberBlock) else {
            return super.visit(node)
        }
        let newMemberBlock = reorderMemberBlock(node.memberBlock, using: plan)
        let reorderedNode = node.with(\.memberBlock, newMemberBlock)

        return super.visit(reorderedNode)
    }

    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        guard let plan = findPlan(for: node.name.text, memberBlock: node.memberBlock) else {
            return super.visit(node)
        }
        let newMemberBlock = reorderMemberBlock(node.memberBlock, using: plan)
        let reorderedNode = node.with(\.memberBlock, newMemberBlock)
        return super.visit(reorderedNode)
    }

    override func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
        guard let plan = findPlan(for: node.name.text, memberBlock: node.memberBlock) else {
            return super.visit(node)
        }
        let newMemberBlock = reorderMemberBlock(node.memberBlock, using: plan)
        let reorderedNode = node.with(\.memberBlock, newMemberBlock)
        return super.visit(reorderedNode)
    }

    override func visit(_ node: ActorDeclSyntax) -> DeclSyntax {
        guard let plan = findPlan(for: node.name.text, memberBlock: node.memberBlock) else {
            return super.visit(node)
        }
        let newMemberBlock = reorderMemberBlock(node.memberBlock, using: plan)
        let reorderedNode = node.with(\.memberBlock, newMemberBlock)
        return super.visit(reorderedNode)
    }

    override func visit(_ node: ProtocolDeclSyntax) -> DeclSyntax {
        guard let plan = findPlan(for: node.name.text, memberBlock: node.memberBlock) else {
            return super.visit(node)
        }
        let newMemberBlock = reorderMemberBlock(node.memberBlock, using: plan)
        let reorderedNode = node.with(\.memberBlock, newMemberBlock)
        return super.visit(reorderedNode)
    }

    // MARK: - Plan Matching

    private func findPlan(for name: String, memberBlock: MemberBlockSyntax) -> TypeRewritePlan? {
        for (location, plan) in plansByLocation where location.name == name {
            if membersMatchByID(memberBlock: memberBlock, plan: plan) {
                return plan
            }
        }

        for (location, plan) in plansByLocation where location.name == name {
            if membersMatchByCount(memberBlock: memberBlock, plan: plan) {
                return plan
            }
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
                item = item.with(\.leadingTrivia, originalFirstTrackedTrivia)
            } else if originalIndex == 0 {
                let normalizedTrivia = inferLeadingTriviaFromItems(allItems, trackedIndices: trackedIndices)
                item = item.with(\.leadingTrivia, normalizedTrivia)
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
        items[trackedIndices[1]].leadingTrivia
    }
}
