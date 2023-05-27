import Foundation

enum ErrorType: Error {
    case nilTokenError
    case isNotDeclaredVariableError
    case isNotDeclaredFunctionError
    case alreadyExistsVariableError
    case alreadyExistsFunctionError
    case variableNotFoundError
    case integerOwerflowError
    case invalidSyntaxError
    case unsupportedArrayError
    case invalidTokenTypeError
    case invalidIndexError
    case invalidValueError
    case invalidArrayError
    case invalidTypeError
    case invalidAppendValueError
    case invalidArrayValueError
    case invalidVariableNameError
    case invalidNodeError
    case invalidFunctionReturnTypeError
    case invalidFunctionParameterNameError
    case invalidFunctionParametersCountError
    case invalidFunctionParameterTypeError




    var description: String {
        switch self {
        case .invalidTokenTypeError:
            return "Token type errorType"
        case .nilTokenError:
            return "Nil token errorType"
        case .integerOwerflowError:
            return "Integer overflow errorType"
        case .invalidSyntaxError:
            return "Syntax errorType"
        case .unsupportedArrayError:
            return "Unsoported array errorType"
        case .invalidIndexError:
            return "Invalid index"
        case .invalidValueError:
            return "Invalid value"
        case .invalidArrayError:
            return "Invalid array"
        case .invalidTypeError:
            return "Invalid type"
        case .invalidAppendValueError:
            return "Invalid append value"
        case .invalidArrayValueError:
            return "Invalid array value"
        case .invalidVariableNameError:
            return "Invalid variable name"
        case .isNotDeclaredVariableError:
            return "Is not declared variable"
        case .alreadyExistsVariableError:
            return "Already exists variable"
        case .variableNotFoundError:
            return "Variable not found"
        case .invalidNodeError:
            return "Invalid node"
        case .alreadyExistsFunctionError:
            return "Already exists function"
        case .invalidFunctionReturnTypeError:
            return "Invalid function return type"
        case .invalidFunctionParameterNameError:
            return "Invalid function parameter name"
        case .isNotDeclaredFunctionError:
            return "Is not declared function"
        case .invalidFunctionParametersCountError:
            return "Invalid function parameters count"
        case .invalidFunctionParameterTypeError:
            return "Invalid function parameter type"

        }
    }
    var value: ErrorType {
        switch self {
        default:
            return self
        }
    }
}
