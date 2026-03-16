import Testing

@testable import swift_marshal

@Suite("Version Tests")
struct VersionTests {

    @Test("Given Version.current, when accessed, then returns a non-empty string")
    func currentVersionIsNotEmpty() {
        #expect(!Version.current.isEmpty)
    }

    @Test("Given Version.number, when accessed, then matches semantic versioning pattern")
    func versionNumberMatchesSemanticPattern() {
        let semverPattern = #"^\d+\.\d+\.\d+(-\w+)?$"#
        let regex = try? Regex(semverPattern)

        #expect(regex != nil)
        #expect(Version.number.contains(regex!))
    }

    @Test("Given Version.current, when accessed, then contains version number")
    func currentContainsVersionNumber() {
        #expect(Version.current.contains(Version.number))
    }

    @Test("Given Version.current, when accessed, then contains platform info in brackets")
    func currentContainsPlatformInfo() {
        let platformPattern = #"\[[\w-]+\]$"#
        let regex = try? Regex(platformPattern)

        #expect(regex != nil)
        #expect(Version.current.contains(regex!))
    }

    @Test("Given Version.current, when accessed on macOS, then contains macos in platform")
    func currentContainsMacOS() {
        #if os(macOS)
            #expect(Version.current.contains("macos"))
        #endif
    }

    @Test("Given Version.current, when accessed on ARM, then contains arm64 in platform")
    func currentContainsArm64() {
        #if arch(arm64)
            #expect(Version.current.contains("arm64"))
        #endif
    }
}
