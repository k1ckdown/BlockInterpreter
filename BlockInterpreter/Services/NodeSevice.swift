import Foundation


enum AllTypes: Equatable {
    case assign
    case ifBlock
    case elifBlock
    case elseBlock
    case forLoop
    case whileLoop
    case function(type: VariableType)
    case returnFunction(type: VariableType)
    case variable(type: VariableType)
    case arithmetic
    case print
    case root
}


class Node {
    private(set) var value: String
    private(set) var type: AllTypes
    private(set) var parent: Node?
    private(set) var children: [Node]
    private(set) var countWasHere: Int
    private(set) var id: Int
    
    init(value: String, type: AllTypes, id: Int) {
        self.value = value
        self.type = type
        self.id = id
        countWasHere = 0
        children = []
    }
    
    func addChild(_ child: Node) {
        children.append(child)
        child.parent = self
    }

    func setCountWasHere(_ count: Int) {
        countWasHere = count
    }

    func getCountWasHere() -> Int {
        return countWasHere
    }
}

