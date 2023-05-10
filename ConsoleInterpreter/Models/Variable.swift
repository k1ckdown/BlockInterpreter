import Foundation


enum VariableType {
    case int
    case double
    case String
    case bool
    case another
    case array
}


struct Variable: IBlock {
    let id: Int
    let type: VariableType
    let name: String
    let value: String
}
