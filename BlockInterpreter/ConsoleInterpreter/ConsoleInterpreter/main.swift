import Foundation


var array: [IBlock] = []

array.append(Loop(id: 1, type: .forLoop, value: "1", isDebug: true))
array.append(BlockDelimiter(type: .begin))
array.append(Loop(id: 2, type: .whileLoop, value: "2", isDebug: true))
array.append(BlockDelimiter(type: .begin))
array.append(Function(id: 3, value: "3", isDebug: true))
array.append(BlockDelimiter(type: .begin))
array.append(Output(id: 5, value: "5", isDebug: true))
array.append(Returning(id: 8, value: "8", isDebug: true))
array.append(BlockDelimiter(type: .end))
array.append(BlockDelimiter(type: .end))
array.append(BlockDelimiter(type: .end))

array.append(Variable(id: 4, type: .int, name: "4", value: "4", isDebug: true))
array.append(Output(id: 12, value: "12", isDebug: false))






let tree = Tree()
tree.setBlocks(array)
tree.buildTree()
print("hi")