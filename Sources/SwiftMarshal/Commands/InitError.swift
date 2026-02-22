import Foundation

enum InitError: Error, LocalizedError {

    // MARK: - Cases

    case configAlreadyExists(String)

    // MARK: - LocalizedError

    var errorDescription: String? {
        switch self {
        case .configAlreadyExists(let path):
            return "Configuration file already exists at \(path). Use --force to overwrite."
        }
    }
}
