import Foundation


let tree = Tree()

var array: [Any] = []

array.append(Variable(id: 1, type: VariableType.int, name: "a", value: "1"))
array.append(Variable(id: 2, type: VariableType.int, name: "b", value: "222"))
array.append(Printing(value: "a"))

array.append(Condition(type: ConditionType.ifBlock, value: "a > b"))
array.append(BlockDelimiter(type: DelimiterType.begin))
array.append(Printing(value: "b"))

array.append(BlockDelimiter(type: DelimiterType.end))

array.append(Printing(value: "I'm OK!"))

tree.buildTree(blocks: array)

for i in tree.rootNode.children {
    print(i)
    if (i.type == AllTypes.ifBlock) {
        print("hello")
        print(i.children[0].type)
        print("hello")
    }
}

print("finish")


