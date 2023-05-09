import Foundation


enum VariableType {
    case int
    case double
    case String
    case bool
    case another
}

// ObjectiveIdentifier
struct Variable {
    let id: Int
    let type: VariableType
    let name: String
    let value: String
    
    func toString() -> String {
        return "Variable(id: \(id), type: \(type), name: \(name), value: \(value))"
    }
}
