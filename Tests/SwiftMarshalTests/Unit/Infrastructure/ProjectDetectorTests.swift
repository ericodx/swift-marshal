import Foundation
import Testing

@testable import swift_marshal

@Suite("ProjectDetector Tests")
struct ProjectDetectorTests {

    @Test("Given a directory with Package.swift, when detecting project, then returns SPM with Sources path")
    func detectsSpmProject() {
        let tempDir = createTempDirectory()
        defer { removeTempDirectory(tempDir) }

        FileManager.default.createFile(atPath: tempDir + "/Package.swift", contents: Data())

        let result = ProjectDetector.detect(in: tempDir)

        #expect(result == .spm(sourcesPath: "Sources"))
    }

    @Test("Given a directory with an .xcodeproj, when detecting project, then returns Xcode with project name as path")
    func detectsXcodeProject() throws {
        let tempDir = createTempDirectory()
        defer { removeTempDirectory(tempDir) }

        let xcodeprojURL = URL(fileURLWithPath: tempDir + "/MyApp.xcodeproj")
        try FileManager.default.createDirectory(at: xcodeprojURL, withIntermediateDirectories: true)

        let result = ProjectDetector.detect(in: tempDir)

        #expect(result == .xcode(sourcesPath: "MyApp"))
    }

    @Test("Given a directory with both Package.swift and .xcodeproj, when detecting project, then prefers SPM")
    func prefersSpmOverXcode() throws {
        let tempDir = createTempDirectory()
        defer { removeTempDirectory(tempDir) }

        FileManager.default.createFile(atPath: tempDir + "/Package.swift", contents: Data())
        let xcodeprojURL = URL(fileURLWithPath: tempDir + "/MyApp.xcodeproj")
        try FileManager.default.createDirectory(at: xcodeprojURL, withIntermediateDirectories: true)

        let result = ProjectDetector.detect(in: tempDir)

        #expect(result == .spm(sourcesPath: "Sources"))
    }

    @Test("Given a directory without Package.swift or .xcodeproj, when detecting project, then returns unknown")
    func detectsUnknownProject() {
        let tempDir = createTempDirectory()
        defer { removeTempDirectory(tempDir) }

        let result = ProjectDetector.detect(in: tempDir)

        #expect(result == .unknown)
    }

    @Test("Given a non-existent directory, when detecting project, then returns unknown")
    func returnsUnknownForNonExistentDirectory() {
        let result = ProjectDetector.detect(in: "/tmp/does-not-exist-\(UUID().uuidString)")

        #expect(result == .unknown)
    }
}
