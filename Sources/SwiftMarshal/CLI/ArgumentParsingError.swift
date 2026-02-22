enum ArgumentParsingError: Error, Sendable {

    case unknownFlag(String)
    case missingValue(String)
}

extension ArgumentParsingError: CustomStringConvertible {

    var description: String {
        switch self {

        case .unknownFlag(let flag):
            "unknown flag '\(flag)'"

        case .missingValue(let flag):
            "missing value for '\(flag)'"

        }
    }
}
