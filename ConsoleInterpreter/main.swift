import Foundation


let tree = Tree()

var array: [Any] = []

array.append(Printing(value: "a"))
array.append(Loop(type: LoopType.forLoop, value: "i in 0...10"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Printing(value: "a"))
array.append(Loop(type: LoopType.forLoop, value: "i in 0...10"))
array.append(BlockDelimiter(type: DelimiterType.begin))


array.append(Loop(type: LoopType.forLoop, value: "i in 0...10"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Printing(value: "c"))

array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Printing(value: "b"))

array.append(BlockDelimiter(type: DelimiterType.end))

array.append(Printing(value: "b"))
array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Printing(value: "b"))
array.append(Printing(value: "ok"))



tree.buildTree(blocks: array)
print("hi")
