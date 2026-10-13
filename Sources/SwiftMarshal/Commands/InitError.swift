import Foundation

enum InitError: Error, LocalizedError {

    // MARK: - Cases

    case configAlreadyExists(String)
    case currentDirectoryUnavailable

    // MARK: - LocalizedError

    var errorDescription: String? {
        switch self {
        case .configAlreadyExists(let path):
            return "Configuration file already exists at \(path). Use --force to overwrite."
        case .currentDirectoryUnavailable:
            return "The current directory is unavailable. It may have been deleted."
        }
    }
}
