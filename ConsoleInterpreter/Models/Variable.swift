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

     
    func getId() -> Int {
        return self.id
    }

    func getType() -> VariableType {
        return self.type
    }

    func getValue() -> String {
        return self.value
    }
    func getName() -> String {
        return self.name
    }
}

