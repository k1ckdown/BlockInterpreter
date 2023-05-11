import Foundation


var array: [IBlock] = []


array.append(Variable(id: 1, type: .int, name: "b", value: "10"))
array.append(Variable(id: 2, type: .int, name: "a", value: "7 + b + 2"))
array.append(Condition(id: 3, type: .ifBlock, value: "(6 + 2) % 8 == 0"))
array.append(BlockDelimiter(type: .begin))
array.append(Variable(id: 4, type: .int, name: "b", value: "b + 100"))
array.append(Condition(id: 5, type: .ifBlock, value: "a != b"))
array.append(BlockDelimiter(type: .begin))
array.append(Variable(id: 6, type: .int, name: "b", value: "b + 100"))
array.append(BlockDelimiter(type: .end))
array.append(BlockDelimiter(type: .end))
array.append(Variable(id: 7, type: .int, name: "b", value: "b + 100"))




let tree = Tree(array)
tree.buildTree()
print("hi")
