import Foundation


var array: [IBlock] = []

array.append(Variable(id: 0, type: .int, name: "b", value: "10"))
array.append(Variable(id: 1, type: .int, name: "a", value: "7 + b + 2"))
array.append(Printing(id: 2, value: "a"))
array.append(Condition(id: 3, type: .ifBlock, value: "a != b"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Variable(id: 4, type: .int, name: "b", value: "b + 10"))
array.append(Variable(id: 5, type: .int, name: "a", value: "a * 2"))
array.append(Printing(id: 6, value: "a"))
array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Condition(id: 7, type: .ifBlock,  value: "(6 + 2) % 8 == 0"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Variable(id: 8, type: .int, name: "b", value: "b + 100"))
array.append(Condition(id: 9, type: .ifBlock,  value: "a != b"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Variable(id: 10, type: .int, name: "b", value: "b + 100"))
array.append(Printing(id: 11, value: "b"))
array.append(BlockDelimiter(type: DelimiterType.end))
array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Printing(id: 12, value: "b"))


let tree = Tree()
tree.setBlocks(array)
tree.buildTree()
print("hi")
