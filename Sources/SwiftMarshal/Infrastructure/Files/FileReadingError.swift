import Foundation

enum FileReadingError: Error, LocalizedError {

    // MARK: - Cases

    case fileNotFound(String)
    case readError(String, Error)

    // MARK: - LocalizedError

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            return "File not found: \(path)"
        case .readError(let path, let underlyingError):
            return "Failed to read '\(path)': \(underlyingError.localizedDescription)"
        }
    }
}
