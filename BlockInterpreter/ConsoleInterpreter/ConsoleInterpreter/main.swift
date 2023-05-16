import Foundation


var array: [IBlock] = []

array.append(Loop(id: 1, type: .forLoop, value: "1", isDebug: true))
array.append(BlockDelimiter(type: .begin))
array.append(Loop(id: 2, type: .whileLoop, value: "2", isDebug: true))
array.append(BlockDelimiter(type: .begin))
array.append(BlockDelimiter(type: .end))
array.append(BlockDelimiter(type: .end))
array.append(Function(id: 3, value: "3", isDebug: true))
array.append(BlockDelimiter(type: .begin))
array.append(BlockDelimiter(type: .end))
array.append(Variable(id: 4, type: .int, name: "4", value: "4", isDebug: true))
array.append(Output(id: 5, value: "5", isDebug: true))
array.append(Continue(id: 6, value: "6", isDebug: true))
array.append(Break(isDebug: true, id: 7, value: "7"))
array.append(Returning(id: 8, value: "8", isDebug: true))
array.append(Condition(isDebug: true, id: 9, type: .ifBlock, value: "9"))
array.append(BlockDelimiter(type: .begin))
array.append(BlockDelimiter(type: .end))





let tree = Tree()
tree.setBlocks(array)
tree.buildTree()
print("hi")