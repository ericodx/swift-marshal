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

        let trackedLayouts = trackedIndices.map { splitLeadingTrivia(allItems[$0].leadingTrivia) }
        let firstSlotSeparator = trackedLayouts[0].separator
        let lineLayout = inferLineLayout(from: trackedLayouts)

        var reorderedTrackedItems: [MemberBlockItemSyntax] = []
        for (newIndex, indexedMember) in plan.reorderedMembers.enumerated() {
            let originalIndex = indexedMember.originalIndex
            let item = allItems[trackedIndices[originalIndex]]
            let (ownSeparator, attached) = trackedLayouts[originalIndex]

            let separator: Trivia
            if newIndex == 0 {
                separator = firstSlotSeparator
            } else {
                let previousOriginalIndex = plan.reorderedMembers[newIndex - 1].originalIndex
                separator = movedSeparator(
                    ownSeparator,
                    isAdjacent: originalIndex == previousOriginalIndex + 1,
                    lineLayout: lineLayout
                )
            }

            let leadingTrivia = joinLeadingTrivia(
                separator: separator,
                attached: attached,
                indentation: ownSeparator.isEmpty ? lineLayout?.indentation : nil
            )
            reorderedTrackedItems.append(item.with(\.leadingTrivia, leadingTrivia))
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

        insertMissingSemicolons(in: &finalItems)

        let newMembers = MemberBlockItemListSyntax(finalItems)
        return memberBlock.with(\.members, newMembers)
    }

    // MARK: - Trivia Layout

    /// Splits leading trivia into the line breaks that separate a member from the previous one,
    /// which belong to its position, and everything after the last of them — indentation, comments,
    /// doc comments — which belongs to the member and moves with it.
    private func splitLeadingTrivia(_ trivia: Trivia) -> (separator: Trivia, attached: Trivia) {
        let pieces = Array(trivia)
        let firstContentIndex = pieces.firstIndex { !isLineBreak($0) && !isIndentation($0) } ?? pieces.endIndex
        guard let lastLineBreakIndex = pieces[..<firstContentIndex].lastIndex(where: isLineBreak) else {
            return ([], trivia)
        }
        let separatorEnd = lastLineBreakIndex + 1
        return (Trivia(pieces: Array(pieces[..<separatorEnd])), Trivia(pieces: Array(pieces[separatorEnd...])))
    }

    private func inferLineLayout(
        from layouts: [(separator: Trivia, attached: Trivia)]
    ) -> (lineBreak: TriviaPiece, indentation: Trivia)? {
        for (separator, attached) in layouts {
            guard let lineBreak = separator.first(where: isLineBreak) else { continue }
            let indentation = Array(attached).prefix(while: isIndentation)
            return (singleLineBreak(like: lineBreak), Trivia(pieces: Array(indentation)))
        }
        return nil
    }

    private func movedSeparator(
        _ ownSeparator: Trivia,
        isAdjacent: Bool,
        lineLayout: (lineBreak: TriviaPiece, indentation: Trivia)?
    ) -> Trivia {
        if isAdjacent {
            return ownSeparator
        }
        if ownSeparator.isEmpty, let lineLayout {
            return ensureBlankLine(in: Trivia(pieces: [lineLayout.lineBreak]))
        }
        return ensureBlankLine(in: ownSeparator)
    }

    private func joinLeadingTrivia(separator: Trivia, attached: Trivia, indentation: Trivia?) -> Trivia {
        let content = Trivia(pieces: Array(Array(attached).drop(while: isIndentation)))
        if separator.isEmpty {
            return content
        }
        if let indentation {
            return separator + indentation + content
        }
        return separator + attached
    }

    private func ensureBlankLine(in separator: Trivia) -> Trivia {
        var pieces = Array(separator)
        let lineBreakCount = pieces.reduce(0) { $0 + lineBreakCount(of: $1) }
        guard lineBreakCount == 1, let index = pieces.firstIndex(where: isLineBreak) else {
            return separator
        }
        switch pieces[index] {
        case .newlines: pieces[index] = .newlines(2)
        case .carriageReturns: pieces[index] = .carriageReturns(2)
        case .carriageReturnLineFeeds: pieces[index] = .carriageReturnLineFeeds(2)
        default: break
        }
        return Trivia(pieces: pieces)
    }

    private func singleLineBreak(like piece: TriviaPiece) -> TriviaPiece {
        switch piece {
        case .carriageReturns: .carriageReturns(1)
        case .carriageReturnLineFeeds: .carriageReturnLineFeeds(1)
        default: .newlines(1)
        }
    }

    private func lineBreakCount(of piece: TriviaPiece) -> Int {
        switch piece {
        case .newlines(let count), .carriageReturns(let count), .carriageReturnLineFeeds(let count): count
        default: 0
        }
    }

    private func isLineBreak(_ piece: TriviaPiece) -> Bool {
        lineBreakCount(of: piece) > 0
    }

    private func isIndentation(_ piece: TriviaPiece) -> Bool {
        switch piece {
        case .spaces, .tabs: true
        default: false
        }
    }

    // MARK: - Semicolons

    /// Swift requires `;` between declarations that share a line. Reordering can place a member
    /// that had no semicolon before another member on the same line, so one is added; the member's
    /// trailing trivia moves after it to keep the original spacing.
    private func insertMissingSemicolons(in items: inout [MemberBlockItemSyntax]) {
        for index in items.indices.dropLast() {
            let item = items[index]
            guard item.semicolon == nil, !items[index + 1].leadingTrivia.contains(where: isLineBreak) else {
                continue
            }
            let trailingTrivia = item.decl.trailingTrivia
            items[index] =
                item
                .with(\.decl, item.decl.with(\.trailingTrivia, []))
                .with(\.semicolon, .semicolonToken(trailingTrivia: trailingTrivia))
        }
    }
}
