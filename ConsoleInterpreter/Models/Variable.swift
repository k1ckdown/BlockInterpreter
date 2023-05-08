import Foundation


enum TypeVariable {
    case int
    case double
    case String
    case bool
    case another
}


struct Variable {
    private let id: Int
    private let type: TypeVariable
    private let name: String
    private let value: String
 
    init(id: Int, type: TypeVariable, value: String, name: String) {
        self.id = id
        self.type = type
        self.value = value
        self.name = name
    }
    
    func toString() -> String {
        return "Variable(id: \(id), type: \(type), name: \(name), value: \(value))"
    }
    
    func getId() -> Int {
        return id
    }
    
    func getType() -> TypeVariable {
        return type
    }
    
    func getName() -> String {
        return name
    }
    
    func getValue() -> String {
        return value
    }
}
