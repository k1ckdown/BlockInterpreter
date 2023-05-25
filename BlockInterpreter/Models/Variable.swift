import Foundation


enum VariableType: String, CaseIterable {
    case int
    case double
    case string
    case bool
    case void
    case arrayInt
    case arrayBool
    case arrayDouble
    case arrayString
    
    var name: String {
        switch self {
        case .int, .double, .bool, .string, .void:
            return self.rawValue.capitalized
        case .arrayInt:
                return "Int[]"
        case .arrayDouble:
            return "Double[]"
        case .arrayString:
            return "String[]"
        case .arrayBool:
            return "Bool[]"
        }
    }
}


struct Variable: IBlock {
    let id: Int
    let type: VariableType
    let name: String
    let value: String
}

