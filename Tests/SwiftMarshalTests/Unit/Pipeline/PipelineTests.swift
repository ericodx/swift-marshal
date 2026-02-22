import Testing

@testable import swift_marshal

@Suite("Pipeline Tests")
struct PipelineTests {

    // MARK: - Tests

    @Test("Given two pipeline stages, when composing them into a pipeline, then processes input through both stages")
    func composeTwoStages() throws {
        let double = DoubleStage()
        let addTen = AddTenStage()

        let pipeline = double.then(addTen)
        let result = try pipeline.process(5)

        #expect(result == 20)
    }

    @Test(
        "Given three pipeline stages, when composing them into a pipeline, then processes input through all three stages"
    )
    func composeThreeStages() throws {
        let double = DoubleStage()
        let addTen = AddTenStage()
        let toString = ToStringStage()

        let pipeline = double.then(addTen).then(toString)
        let result = try pipeline.process(5)

        #expect(result == "20")
    }

    @Test(
        "Given a pipeline with a failing stage, when processing input, then propagates the error from the failing stage"
    )
    func propagatesErrors() throws {
        let failing = FailingStage()
        let addTen = AddTenStage()

        let pipeline = failing.then(addTen)

        #expect(throws: TestError.intentional) {
            try pipeline.process(5)
        }
    }
}
