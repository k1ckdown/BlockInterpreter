import Foundation


var array: [IBlock] = []

array.append(Variable(id: 1, type: .int, name: "a", value: "5"))
array.append(Condition(id: 2, type: .ifBlock, value: "a > b", isDebug: false))
array.append(Flow(id: 3, type: .begin, isDebug: false))
array.append(Variable(id: 4, type: .int, name: "b", value: "5"))
array.append(Loop(id: 5, type: .forLoop, value: "i = 0; i < 10; i++", isDebug: false))
array.append(Flow(id: 6, type: .begin, isDebug: false))
array.append(Flow(id: 4, type: FlowType.breakFlow, isDebug: false))
array.append(Flow(id: 5, type: FlowType.continueFlow, isDebug: false))
array.append(Flow(id: 6, type: FlowType.end, isDebug: false))
array.append(MethodsOfList(id: 7, type: .append, name: "list", value: "5", isDebug: false))
array.append(MethodsOfList(id: 8, type: .remove, name: "list", value: "5", isDebug: false))
array.append(MethodsOfList(id: 9, type: .pop, name: "list", value: "5", isDebug: false))
array.append(Flow(id: 7, type: FlowType.end, isDebug: false))
array.append(Output(id: 8, value: "Hello world", isDebug: false))
array.append(MethodsOfList(id: 9, type: .append, name: "list", value: "5", isDebug: false))
array.append(Variable(id: 10, type: .arrayInt, name: "list", value: "[5, 6]", isDebug: false))

let tree = Tree()
tree.setBlocks(array)
tree.buildTree()
print("hi")

