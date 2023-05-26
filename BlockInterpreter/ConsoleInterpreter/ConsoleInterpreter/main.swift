import Foundation

var array: [IBlock] = []


array.append(Variable(id: 2, type: .arrayInt, name: "c", value: "<int>(10)[5, -1132,13,10000000, 10,-20,0,32,32,32,203]", isDebug: false))
array.append(Loop(id: 3, type: .forLoop, value: "int i = 0; i < 10; i += 1", isDebug: false))
array.append(Flow(id: 4, type: .begin, isDebug: false))
array.append(Loop(id: 5, type: .forLoop, value: "int j = i + 1; j < 10; j += 1", isDebug: false))
array.append(Flow(id: 6, type: .begin, isDebug: false))
array.append(Condition(id: 7, type: .ifBlock, value: "(c[i] > c[j])", isDebug: false))
array.append(Flow(id: 8, type: .begin, isDebug: false))
array.append(Variable(id: 5, type: .double, name: "temp", value: "c[i]", isDebug: false))
array.append(Variable(id: 6, type: .another, name: "c[i]", value: "c[j]", isDebug: false))
array.append(Variable(id: 7, type: .another, name: "c[j]", value: "temp", isDebug: false))

array.append(Flow(id: 8, type: .end, isDebug: false))
array.append(Flow(id: 9, type: .end, isDebug: false))
array.append(Output(id: 10, value: "c", isDebug: false))
array.append(Flow(id: 11, type: .end, isDebug: false))
array.append(Flow(id: 12, type: .end, isDebug: false))
array.append(Output(id: 13, value: "c", isDebug: false))


//array.append(Variable(id: 1, type: .bool, name: "b", value: "true", isDebug: false))
//array.append(Output(id: 2, value: "b", isDebug: false))


let tree = Tree()
tree.setBlocks(array)
tree.buildTree()

let interpreter = Interpreter()
interpreter.setTreeAST(tree.rootNode)
print(interpreter.getPrintResult())

