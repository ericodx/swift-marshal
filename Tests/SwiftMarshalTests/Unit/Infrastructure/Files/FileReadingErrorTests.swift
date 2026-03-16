import Foundation
import Testing

@testable import swift_marshal

@Suite("FileReadingError Tests")
struct FileReadingErrorTests {

    // MARK: - Error Cases

    @Test("Given fileNotFound error, when checking case, then is fileNotFound with path")
    func fileNotFoundCase() {
        let error = FileReadingError.fileNotFound("/path/to/file.swift")

        if case .fileNotFound(let path) = error {
            #expect(path == "/path/to/file.swift")
        } else {
            Issue.record("Expected fileNotFound case")
        }
    }

    @Test("Given readError, when checking case, then is readError with path and underlying error")
    func readErrorCase() {
        let underlyingError = NSError(domain: "test", code: 1)
        let error = FileReadingError.readError("/path/to/file.swift", underlyingError)

        if case .readError(let path, _) = error {
            #expect(path == "/path/to/file.swift")
        } else {
            Issue.record("Expected readError case")
        }
    }

    // MARK: - Error Descriptions

    @Test("Given fileNotFound error, when getting description, then includes path")
    func fileNotFoundDescription() {
        let error = FileReadingError.fileNotFound("/missing/file.swift")

        #expect(error.errorDescription?.contains("File not found") == true)
        #expect(error.errorDescription?.contains("/missing/file.swift") == true)
    }

    @Test("Given readError, when getting description, then includes path and underlying error")
    func readErrorDescription() {
        let underlyingError = NSError(
            domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Permission denied"])
        let error = FileReadingError.readError("/protected/file.swift", underlyingError)

        #expect(error.errorDescription?.contains("Failed to read") == true)
        #expect(error.errorDescription?.contains("/protected/file.swift") == true)
    }

    // MARK: - Error Protocol Conformance

    @Test("Given FileReadingError, when used as LocalizedError, then has localized description")
    func conformsToLocalizedError() {
        let error: any Error = FileReadingError.fileNotFound("/test/path")

        #expect(error.localizedDescription.contains("File not found"))
    }
}
