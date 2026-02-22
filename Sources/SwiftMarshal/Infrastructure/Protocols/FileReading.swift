protocol FileReading {
    func read(at path: String) async throws -> String
}
