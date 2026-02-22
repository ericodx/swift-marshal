import Testing

@testable import swift_marshal

@Suite("ConfigurationMapper Tests")
struct ConfigurationMapperTests {

    let mapper = ConfigurationMapper()

    // MARK: - Version Mapping

    @Test("Given a raw configuration with version, when mapping with ConfigurationMapper, then maps version directly")
    func mapsVersion() {
        let raw = RawConfiguration(version: 2, memberRules: [], extensionsStrategy: nil, respectBoundaries: nil)
        let config = mapper.map(raw)

        #expect(config.version == 2)
    }

    // MARK: - Simple Rules Mapping

    @Test(
        "Given a raw configuration with valid member kind, when mapping with ConfigurationMapper, then maps valid simple member kind"
    )
    func mapsValidSimpleKind() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.simple("initializer")],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .simple(.initializer))
    }

    @Test(
        "Given a raw configuration with invalid member kind, when mapping with ConfigurationMapper, then ignores invalid simple member kind"
    )
    func ignoresInvalidSimpleKind() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.simple("invalid_kind")],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules == Configuration.defaultValue.memberOrderingRules)
    }

    @Test(
        "Given all MemberKind values in raw configuration, when mapping with ConfigurationMapper, then maps all valid MemberKind values"
    )
    func mapsAllValidMemberKinds() {
        for kind in MemberKind.allCases {
            let raw = RawConfiguration(
                version: 1,
                memberRules: [.simple(kind.rawValue)],
                extensionsStrategy: nil,
                respectBoundaries: nil
            )
            let config = mapper.map(raw)

            #expect(config.memberOrderingRules.count == 1)
            #expect(config.memberOrderingRules[0] == .simple(kind))
        }
    }

    // MARK: - Property Rules Mapping

    @Test(
        "Given a raw configuration with property annotation filter, when mapping with ConfigurationMapper, then maps property with annotated filter"
    )
    func mapsPropertyAnnotated() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.property(annotated: true, visibility: nil)],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .property(annotated: true, visibility: nil))
    }

    @Test(
        "Given a raw configuration with property visibility filter, when mapping with ConfigurationMapper, then maps property with valid visibility"
    )
    func mapsPropertyValidVisibility() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.property(annotated: nil, visibility: "public")],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .property(annotated: nil, visibility: .publicAccess))
    }

    @Test(
        "Given a raw configuration with invalid property visibility, when mapping with ConfigurationMapper, then maps property with invalid visibility to nil"
    )
    func mapsPropertyInvalidVisibility() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.property(annotated: nil, visibility: "invalid")],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .property(annotated: nil, visibility: nil))
    }

    @Test(
        "Given all Visibility values for property, when mapping with ConfigurationMapper, then maps all valid Visibility values for property"
    )
    func mapsAllValidVisibilitiesForProperty() {
        for visibility in Visibility.allCases {
            let raw = RawConfiguration(
                version: 1,
                memberRules: [.property(annotated: nil, visibility: visibility.rawValue)],
                extensionsStrategy: nil,
                respectBoundaries: nil
            )
            let config = mapper.map(raw)

            #expect(config.memberOrderingRules.count == 1)
            #expect(config.memberOrderingRules[0] == .property(annotated: nil, visibility: visibility))
        }
    }

    // MARK: - Method Rules Mapping

    @Test(
        "Given a raw configuration with static method kind, when mapping with ConfigurationMapper, then maps method with static kind"
    )
    func mapsMethodStaticKind() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.method(kind: "static", visibility: nil, annotated: nil)],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .method(kind: .staticMethod, visibility: nil, annotated: nil))
    }

    @Test(
        "Given a raw configuration with instance method kind, when mapping with ConfigurationMapper, then maps method with instance kind"
    )
    func mapsMethodInstanceKind() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.method(kind: "instance", visibility: nil, annotated: nil)],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .method(kind: .instance, visibility: nil, annotated: nil))
    }

    @Test(
        "Given a raw configuration with invalid method kind, when mapping with ConfigurationMapper, then maps method with invalid kind to nil"
    )
    func mapsMethodInvalidKind() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.method(kind: "invalid", visibility: nil, annotated: nil)],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .method(kind: nil, visibility: nil, annotated: nil))
    }

    @Test(
        "Given a raw configuration with method visibility filter, when mapping with ConfigurationMapper, then maps method with valid visibility"
    )
    func mapsMethodValidVisibility() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.method(kind: nil, visibility: "private", annotated: nil)],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .method(kind: nil, visibility: .privateAccess, annotated: nil))
    }

    // MARK: - Extensions Strategy Mapping

    @Test(
        "Given a raw configuration with separate extensions strategy, when mapping with ConfigurationMapper, then maps separate strategy"
    )
    func mapsSeparateStrategy() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: "separate",
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.extensionsStrategy == .separate)
    }

    @Test(
        "Given a raw configuration with merge extensions strategy, when mapping with ConfigurationMapper, then maps merge strategy"
    )
    func mapsMergeStrategy() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: "merge",
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.extensionsStrategy == .merge)
    }

    @Test(
        "Given a raw configuration with nil extensions strategy, when mapping with ConfigurationMapper, then defaults to separate for nil strategy"
    )
    func defaultsToSeparateForNilStrategy() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.extensionsStrategy == .separate)
    }

    @Test(
        "Given a raw configuration with invalid extensions strategy, when mapping with ConfigurationMapper, then defaults to separate for invalid strategy"
    )
    func defaultsToSeparateForInvalidStrategy() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: "invalid",
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.extensionsStrategy == .separate)
    }

    // MARK: - Respect Boundaries Mapping

    @Test(
        "Given a raw configuration with respect_boundaries true, when mapping with ConfigurationMapper, then maps respect_boundaries true"
    )
    func mapsRespectBoundariesTrue() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: true
        )
        let config = mapper.map(raw)

        #expect(config.respectBoundaries == true)
    }

    @Test(
        "Given a raw configuration with respect_boundaries false, when mapping with ConfigurationMapper, then maps respect_boundaries false"
    )
    func mapsRespectBoundariesFalse() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: false
        )
        let config = mapper.map(raw)

        #expect(config.respectBoundaries == false)
    }

    @Test(
        "Given a raw configuration with nil respect_boundaries, when mapping with ConfigurationMapper, then defaults to true for nil respect_boundaries"
    )
    func defaultsToTrueForNilRespectBoundaries() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.respectBoundaries == true)
    }

    // MARK: - Default Rules

    @Test(
        "Given a raw configuration with all invalid rules, when mapping with ConfigurationMapper, then uses default rules when all rules are invalid"
    )
    func usesDefaultRulesWhenAllInvalid() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.simple("invalid1"), .simple("invalid2")],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules == Configuration.defaultValue.memberOrderingRules)
    }

    @Test(
        "Given a raw configuration with empty member rules, when mapping with ConfigurationMapper, then uses default rules when member rules are empty"
    )
    func usesDefaultRulesWhenEmpty() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules == Configuration.defaultValue.memberOrderingRules)
    }
}
