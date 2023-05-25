import Foundation


enum VariableType: String {
    case int
    case double
    case string
    case bool
    case void
    case arrayInt
    case arrayDouble
    case arrayString
    case arrayBool
}


struct Variable: IBlock {
    let id: Int
    let type: VariableType
    let name: String
    let value: String
    let isDebug: Bool

    init(id: Int, type: VariableType, name: String, value: String, isDebug: Bool = false) {
        self.id = id
        self.type = type
        self.name = name
        self.value = value
        self.isDebug = isDebug
    }
}
