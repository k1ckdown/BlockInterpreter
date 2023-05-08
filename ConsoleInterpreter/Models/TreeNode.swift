import Foundation


class TreeNode {
    private(set) var value: String
    private(set) var type: AllTypes
    private(set) var parent: TreeNode?
    private(set) var children: [TreeNode]
    private(set) var countWasHere: Int
    
    init(value: String, type: AllTypes) {
        self.value = value
        self.type = type
        self.countWasHere = 0
        self.children = []
    }
    
    func addChild(_ child: TreeNode) {
        children.append(child)
        child.parent = self
    }
}


