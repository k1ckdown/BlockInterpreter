import Foundation
 
 
class Variable {
    private(set) var id: Int
    private(set) var type: TypeVariable
    private(set) var name: String
    private(set) var value: String
 
    init(id: Int, type: TypeVariable, value: String, name: String) {
        self.id = id
        self.type = type
        self.value = value
        self.name = name
    }
 
    func setValue(value: String) {
        self.value = value
    }
}

