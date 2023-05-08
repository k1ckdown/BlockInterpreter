import Foundation


enum AllTypes {
    case assign
    case ifBlock
    case begin
    case end
    case loop
    case function
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
    
    init(value: String, type: AllTypes) {
        self.value = value
        self.type = type
        self.countWasHere = 0
        self.children = []
    }
    
    func addChild(_ child: Node) {
        children.append(child)
        child.parent = self
    }
}
