import Foundation


enum AllTypes {
    case assign
    case ifBlock
    case elifBlock
    case elseBlock
    case loop
    case function
    case returnFunction
    case variable
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
    private(set) var isDebug: Bool

    init(value: String, type: AllTypes, id: Int, isDebug: Bool = false) {
        self.value = value
        self.type = type
        self.id = id
        self.isDebug = isDebug
        countWasHere = 0
        children = []
    }
    
    func addChild(_ child: Node) {
        children.append(child)
        child.parent = self
    }
}
