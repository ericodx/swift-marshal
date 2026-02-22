import Foundation

struct ConfigurationLoader {

    func parse(_ content: String) throws -> RawConfiguration {
        let lines = content.components(separatedBy: .newlines)
        var index = 0
        var version = 1
        var memberRules: [RawMemberRule] = []
        var strategy: String?
        var respectBoundaries: Bool?

        while index < lines.count {
            let stripped = stripComment(lines[index])
            let trimmed = stripped.trimmingCharacters(in: .whitespaces)

            guard !trimmed.isEmpty else {
                index += 1
                continue
            }

            let indent = leadingSpaces(stripped)

            guard indent == 0 else {
                index += 1
                continue
            }

            if trimmed.hasPrefix("version:") {
                let raw = String(trimmed.dropFirst("version:".count)).trimmingCharacters(in: .whitespaces)
                version = Int(raw) ?? 1
                index += 1
            } else if trimmed == "ordering:" {
                index += 1
                index = parseOrdering(lines: lines, from: index, into: &memberRules)
            } else if trimmed == "extensions:" {
                index += 1
                index = parseExtensions(
                    lines: lines,
                    from: index,
                    strategy: &strategy,
                    respectBoundaries: &respectBoundaries
                )
            } else {
                index += 1
            }
        }

        return RawConfiguration(
            version: version,
            memberRules: memberRules,
            extensionsStrategy: strategy,
            respectBoundaries: respectBoundaries
        )
    }

    private func parseOrdering(lines: [String], from startIndex: Int, into memberRules: inout [RawMemberRule]) -> Int {
        parseSection(lines: lines, from: startIndex) { index, trimmed in
            if trimmed == "members:" {
                index += 1
                index = parseMembersList(lines: lines, from: index, into: &memberRules)
            } else {
                index += 1
            }
        }
    }

    private func parseMembersList(
        lines: [String],
        from startIndex: Int,
        into memberRules: inout [RawMemberRule]
    ) -> Int {
        var index = startIndex
        var listIndent: Int?

        while index < lines.count {
            let stripped = stripComment(lines[index])
            let trimmed = stripped.trimmingCharacters(in: .whitespaces)

            guard !trimmed.isEmpty else {
                index += 1
                continue
            }

            let indent = leadingSpaces(stripped)

            if let listIndent, indent < listIndent {
                return index
            }

            guard trimmed.hasPrefix("- ") else {
                index += 1
                continue
            }

            if listIndent == nil {
                listIndent = indent
            }

            let itemContent = String(trimmed.dropFirst(2))

            if itemContent.hasSuffix(":") {
                let ruleName = String(itemContent.dropLast())
                index += 1
                let (nextIndex, attrs) = parseComplexRuleAttributes(
                    lines: lines,
                    from: index,
                    minimumIndent: indent
                )
                index = nextIndex

                if let rule = buildComplexRule(name: ruleName, attrs: attrs) {
                    memberRules.append(rule)
                }
            } else {
                memberRules.append(.simple(itemContent))
                index += 1
            }
        }

        return index
    }

    private func parseComplexRuleAttributes(
        lines: [String],
        from startIndex: Int,
        minimumIndent: Int
    ) -> (Int, [String: String]) {
        var index = startIndex
        var attrs: [String: String] = [:]

        while index < lines.count {
            let attrStripped = stripComment(lines[index])
            let attrTrimmed = attrStripped.trimmingCharacters(in: .whitespaces)

            guard !attrTrimmed.isEmpty else {
                index += 1
                continue
            }

            guard leadingSpaces(attrStripped) > minimumIndent else {
                break
            }

            if let (key, value) = parseKeyValue(attrTrimmed) {
                attrs[key] = value
            }

            index += 1
        }

        return (index, attrs)
    }

    private func parseExtensions(
        lines: [String],
        from startIndex: Int,
        strategy: inout String?,
        respectBoundaries: inout Bool?
    ) -> Int {
        parseSection(lines: lines, from: startIndex) { index, trimmed in
            if trimmed.hasPrefix("strategy:") {
                let raw = String(trimmed.dropFirst("strategy:".count)).trimmingCharacters(in: .whitespaces)
                strategy = raw.isEmpty ? nil : raw
            } else if trimmed.hasPrefix("respect_boundaries:") {
                let raw = String(trimmed.dropFirst("respect_boundaries:".count)).trimmingCharacters(in: .whitespaces)
                switch raw.lowercased() {

                case "true", "yes":
                    respectBoundaries = true

                case "false", "no":
                    respectBoundaries = false

                default:
                    respectBoundaries = nil

                }
            }

            index += 1
        }
    }

    private func parseSection(
        lines: [String],
        from startIndex: Int,
        handler: (inout Int, String) -> Void
    ) -> Int {
        var index = startIndex

        while index < lines.count {
            let stripped = stripComment(lines[index])
            let trimmed = stripped.trimmingCharacters(in: .whitespaces)

            guard !trimmed.isEmpty else {
                index += 1
                continue
            }

            guard leadingSpaces(stripped) > 0 else {
                return index
            }

            handler(&index, trimmed)
        }

        return index
    }

    private func stripComment(_ line: String) -> String {
        guard !line.trimmingCharacters(in: .whitespaces).hasPrefix("#") else {
            return ""
        }

        guard let range = line.range(of: " #") else {
            return line
        }

        return String(line[..<range.lowerBound])
    }

    private func leadingSpaces(_ line: String) -> Int {
        line.prefix(while: { $0 == " " }).count
    }

    private func parseKeyValue(_ trimmed: String) -> (String, String)? {
        guard let colonIndex = trimmed.firstIndex(of: ":") else {
            return nil
        }

        let key = String(trimmed[..<colonIndex])
        let value = String(trimmed[trimmed.index(after: colonIndex)...])
            .trimmingCharacters(in: .whitespaces)

        return (key, value)
    }

    private func buildComplexRule(name: String, attrs: [String: String]) -> RawMemberRule? {
        switch name {

        case "property":
            return .property(
                annotated: boolFromAttr(attrs["annotated"]),
                visibility: attrs["visibility"]
            )

        case "method":
            return .method(
                kind: attrs["kind"],
                visibility: attrs["visibility"],
                annotated: boolFromAttr(attrs["annotated"])
            )

        default:
            return nil

        }
    }

    private func boolFromAttr(_ raw: String?) -> Bool? {
        guard let raw else {
            return nil
        }

        switch raw.lowercased() {

        case "true", "yes":
            return true

        case "false", "no":
            return false

        default:
            return nil

        }
    }
}
