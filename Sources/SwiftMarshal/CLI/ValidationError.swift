import Foundation

struct ValidationError: Error, LocalizedError, Sendable {

    init(_ message: String) {
        self.message = message
    }

    let message: String

    var errorDescription: String? {
        message
    }
}
