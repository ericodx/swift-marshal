import Foundation

enum FileWritingError: Error, LocalizedError {

    // MARK: - Cases

    case writeError(String, Error)

    // MARK: - LocalizedError

    var errorDescription: String? {
        switch self {
        case .writeError(let path, let underlyingError):
            return "Failed to write '\(path)': \(underlyingError.localizedDescription)"
        }
    }
}
