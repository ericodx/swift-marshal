protocol Stage<Input, Output>: Sendable {

    // MARK: - Associated Types

    associatedtype Input: Sendable
    associatedtype Output: Sendable

    // MARK: - Methods

    func process(_ input: Input) throws -> Output
}

// MARK: - Stage + Composition

extension Stage {
    func then<Next: Stage>(_ next: Next) -> Pipeline<Self, Next> where Output == Next.Input {
        Pipeline(self, next)
    }
}
