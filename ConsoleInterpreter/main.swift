//
//  main.swift
//  ConsoleInterpreter
//

import Foundation

var array: [IBlock] = []

array.append(Variable(id: 0, type: .int, name: "b", value: "0"))
array.append(Variable(id: 1, type: .String, name: "a", value: "13"))

array.append(Loop(id: 3, type: .forLoop, value: "i = 0; i > -9; i = i - 1"))
array.append(Flow(type: .begin))

array.append(Condition(id: 6,type: .ifBlock, value: "a >= -30"))
array.append(Flow(type: .begin))
array.append(Variable(id: 8, type: .int, name: "b", value: "b + 100"))
array.append(Variable(id: 9, type: .int, name: "a", value: "a - 10"))

array.append(Output(id: 10, value: "a"))
array.append(Flow(type: .end))


array.append(Flow(type: .end))


let tree = Tree()
tree.setBlocks(array)
tree.buildTree()

let interpreter = Interpreter()
interpreter.setTreeAST(tree.rootNode)
print(interpreter.getPrintResult())
