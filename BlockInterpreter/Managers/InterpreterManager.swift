//
//  InterpreterManager.swift
//  BlockInterpreter
//

import Foundation

final class InterpreterManager {
    
    private let tree: Tree
    private let interpreter: Interpreter
    
    init() {
        tree = Tree()
        interpreter = Interpreter()
    }
    
    func getConsoleContent(blocks: [IBlock]) -> String {
        tree.setBlocks(blocks)
        tree.buildTree()
        interpreter.setTreeAST(tree.rootNode)
        return interpreter.getPrintResult()
    }
    
}

