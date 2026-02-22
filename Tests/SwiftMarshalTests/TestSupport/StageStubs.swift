@testable import swift_marshal

// MARK: - Integer Stages

struct DoubleStage: Stage {
    func process(_ input: Int) throws -> Int {
        input * 2
    }
}

struct AddTenStage: Stage {
    func process(_ input: Int) throws -> Int {
        input + 10
    }
}

// MARK: - Conversion Stages

struct ToStringStage: Stage {
    func process(_ input: Int) throws -> String {
        "\(input)"
    }
}

// MARK: - Error Stages

struct FailingStage: Stage {
    func process(_ input: Int) throws -> Int {
        throw TestError.intentional
    }
}
