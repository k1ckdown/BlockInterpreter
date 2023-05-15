import Foundation


var array: [IBlock] = []

array.append(Loop(id: 1, type: LoopType.forLoop, value: "for"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Continue(id: 12, value: "continue"))
array.append(Break(id: 1, value: "break"))
array.append(BlockDelimiter(type: DelimiterType.end))

let tree = Tree()
tree.setBlocks(array)
tree.buildTree()
print("hi")