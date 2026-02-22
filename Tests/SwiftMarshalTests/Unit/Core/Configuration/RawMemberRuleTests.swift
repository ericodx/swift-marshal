import Testing

@testable import swift_marshal

@Suite("RawMemberRule Tests")
struct RawMemberRuleTests {

    @Test("Given simple rule, when checking case, then is simple with kind")
    func simpleCase() {
        let rule = RawMemberRule.simple("initializer")

        if case .simple(let kind) = rule {
            #expect(kind == "initializer")
        } else {
            Issue.record("Expected simple case")
        }
    }

    @Test("Given property rule, when checking case, then is property with options")
    func propertyCase() {
        let rule = RawMemberRule.property(annotated: true, visibility: "public")

        if case .property(let annotated, let visibility) = rule {
            #expect(annotated == true)
            #expect(visibility == "public")
        } else {
            Issue.record("Expected property case")
        }
    }

    @Test("Given property rule with nil values, when checking case, then has nil options")
    func propertyCaseWithNils() {
        let rule = RawMemberRule.property(annotated: nil, visibility: nil)

        if case .property(let annotated, let visibility) = rule {
            #expect(annotated == nil)
            #expect(visibility == nil)
        } else {
            Issue.record("Expected property case")
        }
    }

    @Test("Given method rule, when checking case, then is method with options")
    func methodCase() {
        let rule = RawMemberRule.method(kind: "static", visibility: "private", annotated: false)

        if case .method(let kind, let visibility, let annotated) = rule {
            #expect(kind == "static")
            #expect(visibility == "private")
            #expect(annotated == false)
        } else {
            Issue.record("Expected method case")
        }
    }

    @Test("Given method rule with nil values, when checking case, then has nil options")
    func methodCaseWithNils() {
        let rule = RawMemberRule.method(kind: nil, visibility: nil, annotated: nil)

        if case .method(let kind, let visibility, let annotated) = rule {
            #expect(kind == nil)
            #expect(visibility == nil)
            #expect(annotated == nil)
        } else {
            Issue.record("Expected method case")
        }
    }

    // MARK: - Equatable

    @Test("Given two equal simple rules, when comparing, then are equal")
    func equatableSimple() {
        let rule1 = RawMemberRule.simple("initializer")
        let rule2 = RawMemberRule.simple("initializer")

        #expect(rule1 == rule2)
    }

    @Test("Given two different simple rules, when comparing, then are not equal")
    func notEqualSimple() {
        let rule1 = RawMemberRule.simple("initializer")
        let rule2 = RawMemberRule.simple("instance_method")

        #expect(rule1 != rule2)
    }

    @Test("Given two equal property rules, when comparing, then are equal")
    func equatableProperty() {
        let rule1 = RawMemberRule.property(annotated: true, visibility: "public")
        let rule2 = RawMemberRule.property(annotated: true, visibility: "public")

        #expect(rule1 == rule2)
    }

    @Test("Given two equal method rules, when comparing, then are equal")
    func equatableMethod() {
        let rule1 = RawMemberRule.method(kind: "static", visibility: "private", annotated: true)
        let rule2 = RawMemberRule.method(kind: "static", visibility: "private", annotated: true)

        #expect(rule1 == rule2)
    }

    @Test("Given simple and property rules, when comparing, then are not equal")
    func notEqualDifferentCases() {
        let rule1 = RawMemberRule.simple("instance_property")
        let rule2 = RawMemberRule.property(annotated: nil, visibility: nil)

        #expect(rule1 != rule2)
    }

    // MARK: - Sendable

    @Test("Given RawMemberRule, when stored as Sendable, then can be recovered with same value")
    func isSendable() {
        let original = RawMemberRule.simple("test")
        let sendable: any Sendable = original

        #expect((sendable as? RawMemberRule) == original)
    }
}
