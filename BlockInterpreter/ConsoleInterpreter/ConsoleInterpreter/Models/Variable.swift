import Foundation


enum VariableType: String {
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
    let isDebug: Bool
}
