import Testing

@testable import swift_marshal

@Suite("TypeLocation Tests")
struct TypeLocationTests {

    @Test("Given TypeLocation, when accessing name, then returns correct name")
    func accessesName() {
        let location = TypeLocation(name: "MyStruct", line: 1)

        #expect(location.name == "MyStruct")
    }

    @Test("Given TypeLocation, when accessing line, then returns correct line")
    func accessesLine() {
        let location = TypeLocation(name: "Test", line: 42)

        #expect(location.line == 42)
    }

    // MARK: - Hashable

    @Test("Given two equal TypeLocations, when comparing, then are equal")
    func equatable() {
        let location1 = TypeLocation(name: "Test", line: 10)
        let location2 = TypeLocation(name: "Test", line: 10)

        #expect(location1 == location2)
    }

    @Test("Given two TypeLocations with different names, when comparing, then are not equal")
    func notEqualDifferentName() {
        let location1 = TypeLocation(name: "First", line: 10)
        let location2 = TypeLocation(name: "Second", line: 10)

        #expect(location1 != location2)
    }

    @Test("Given two TypeLocations with different lines, when comparing, then are not equal")
    func notEqualDifferentLine() {
        let location1 = TypeLocation(name: "Test", line: 10)
        let location2 = TypeLocation(name: "Test", line: 20)

        #expect(location1 != location2)
    }

    @Test("Given TypeLocation, when used as dictionary key, then works correctly")
    func worksAsDictionaryKey() {
        var dict: [TypeLocation: String] = [:]
        let location = TypeLocation(name: "Test", line: 5)

        dict[location] = "value"

        #expect(dict[location] == "value")
    }

    @Test("Given equal TypeLocations, when hashing, then produce same hash")
    func hashable() {
        let location1 = TypeLocation(name: "Test", line: 10)
        let location2 = TypeLocation(name: "Test", line: 10)

        #expect(location1.hashValue == location2.hashValue)
    }
}
