import Testing

@testable import swift_marshal

@Suite("RawConfiguration Tests")
struct RawConfigurationTests {

    // MARK: - Tests

    @Test("Given RawConfiguration, when accessing version, then returns correct version")
    func accessesVersion() {
        let config = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )

        #expect(config.version == 1)
    }

    @Test("Given RawConfiguration, when accessing memberRules, then returns rules")
    func accessesMemberRules() {
        let rules: [RawMemberRule] = [.simple("initializer"), .simple("instance_method")]
        let config = RawConfiguration(
            version: 1,
            memberRules: rules,
            extensionsStrategy: nil,
            respectBoundaries: nil
        )

        #expect(config.memberRules.count == 2)
    }

    @Test("Given RawConfiguration, when accessing extensionsStrategy, then returns strategy")
    func accessesExtensionsStrategy() {
        let config = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: "separate",
            respectBoundaries: nil
        )

        #expect(config.extensionsStrategy == "separate")
    }

    @Test("Given RawConfiguration, when accessing respectBoundaries, then returns value")
    func accessesRespectBoundaries() {
        let config = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: true
        )

        #expect(config.respectBoundaries == true)
    }

    @Test("Given two equal RawConfigurations, when comparing, then are equal")
    func equatable() {
        let config1 = RawConfiguration(
            version: 1,
            memberRules: [.simple("initializer")],
            extensionsStrategy: "separate",
            respectBoundaries: true
        )
        let config2 = RawConfiguration(
            version: 1,
            memberRules: [.simple("initializer")],
            extensionsStrategy: "separate",
            respectBoundaries: true
        )

        #expect(config1 == config2)
    }

    @Test("Given RawConfiguration, when stored as Sendable, then can be recovered with same version")
    func isSendable() {
        let original = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let sendable: any Sendable = original

        #expect((sendable as? RawConfiguration)?.version == original.version)
    }
}
