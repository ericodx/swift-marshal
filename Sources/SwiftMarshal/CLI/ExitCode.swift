struct ExitCode: Error, Sendable {

    init(_ rawValue: Int32) {
        self.rawValue = rawValue
    }

    let rawValue: Int32

    static let success = ExitCode(0)
    static let error = ExitCode(2)
}
