import Foundation


var array: [IBlock] = []

array.append(Condition(id: 0, type: .ifBlock, value: "a > 5"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Condition(id: 0, type: .ifBlock, value: "a > 5"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Condition(id: 0, type: .ifBlock, value: "a > 5"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Condition(id: 0, type: .elseBlock, value: "a > 5"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(BlockDelimiter(type: DelimiterType.end))
array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Condition(id: 1, type: .elifBlock, value: "b > 01"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Condition(id: 2, type: .elseBlock, value: "c > 10"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(BlockDelimiter(type: DelimiterType.end))


let tree = Tree()
tree.setBlocks(array)
tree.buildTree()
print("hi")