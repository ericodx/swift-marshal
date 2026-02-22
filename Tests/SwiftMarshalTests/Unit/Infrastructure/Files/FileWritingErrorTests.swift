import Foundation
import Testing

@testable import swift_marshal

@Suite("FileWritingError Tests")
struct FileWritingErrorTests {

    // MARK: - Error Cases

    @Test("Given writeError, when checking case, then is writeError with path and underlying error")
    func writeErrorCase() {
        let underlyingError = NSError(domain: "test", code: 1)
        let error = FileWritingError.writeError("/path/to/file.swift", underlyingError)

        if case .writeError(let path, _) = error {
            #expect(path == "/path/to/file.swift")
        } else {
            Issue.record("Expected writeError case")
        }
    }

    // MARK: - Error Descriptions

    @Test("Given writeError, when getting description, then includes path")
    func writeErrorDescriptionIncludesPath() {
        let underlyingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Disk full"])
        let error = FileWritingError.writeError("/output/file.swift", underlyingError)

        #expect(error.errorDescription?.contains("Failed to write") == true)
        #expect(error.errorDescription?.contains("/output/file.swift") == true)
    }

    @Test("Given writeError, when getting description, then includes underlying error description")
    func writeErrorDescriptionIncludesUnderlyingError() {
        let underlyingError = NSError(
            domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Permission denied"])
        let error = FileWritingError.writeError("/protected/file.swift", underlyingError)

        #expect(error.errorDescription?.contains("Permission denied") == true)
    }

    // MARK: - Error Protocol Conformance

    @Test("Given FileWritingError, when used as LocalizedError, then has localized description")
    func conformsToLocalizedError() {
        let underlyingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        let error: any Error = FileWritingError.writeError("/test/path", underlyingError)

        #expect(error.localizedDescription.contains("Failed to write"))
    }
}
