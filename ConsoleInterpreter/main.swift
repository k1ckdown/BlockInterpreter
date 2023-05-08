import Foundation
 

let root = TreeNode(value: "", type: AllTypes.assign)
let node1 = TreeNode(value: "a", type: AllTypes.variable)
let node2 = TreeNode(value: "12 + 15 - 2", type: AllTypes.arithmetic)

root.addChild(node1)
root.addChild(node2)
