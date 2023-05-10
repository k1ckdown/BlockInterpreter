import Foundation


var array: [Any] = []

array.append(Printing(value: "a"))
array.append(Loop(type: LoopType.forLoop, value: "i in 0...10"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Printing(value: "b"))
array.append(Loop(type: LoopType.forLoop, value: "i in 0...10"))
array.append(BlockDelimiter(type: DelimiterType.begin))


array.append(Loop(type: LoopType.forLoop, value: "i in 0...10"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Printing(value: "c"))

array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Printing(value: "d"))

array.append(BlockDelimiter(type: DelimiterType.end))

array.append(Printing(value: "e"))
array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Printing(value: "f"))
array.append(Printing(value: "ok"))


/// do id for Structure
let tree = Tree(array)
tree.buildTree()
print("hi")
