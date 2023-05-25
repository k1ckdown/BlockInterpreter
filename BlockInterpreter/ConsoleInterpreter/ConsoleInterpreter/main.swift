import Foundation


var array: [IBlock] = []

array.append(ArrayMethod(id: 0, type: .append, name: "a", value: "21", isDebug: false))
array.append(Function(id: 1, name: "a", type: .int, value: "21", isDebug: false))
array.append(Flow(id: 2, type: .begin, isDebug: false))
array.append(Returning(id: 3, type: .int, value: "a", isDebug: false))
array.append(Flow(id: 4, type: .end, isDebug: false))



let tree = Tree()
tree.setBlocks(array)
tree.buildTree()
print("hi")

