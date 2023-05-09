import Foundation


let tree = Tree()

var array: [Any] = []

array.append(Printing(value: "a"))
array.append(Condition(type: ConditionType.ifBlock, value: "a > b"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Printing(value: "a"))
array.append(Condition(type: ConditionType.ifBlock, value: "a > b"))
array.append(BlockDelimiter(type: DelimiterType.begin))

array.append(Condition(type: ConditionType.ifBlock, value: "a > b"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Printing(value: "c"))

array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Printing(value: "b"))

array.append(BlockDelimiter(type: DelimiterType.end))

array.append(Printing(value: "b"))
array.append(BlockDelimiter(type: DelimiterType.end))
array.append(Printing(value: "b"))


tree.buildTree(blocks: array)
print("Hi")
