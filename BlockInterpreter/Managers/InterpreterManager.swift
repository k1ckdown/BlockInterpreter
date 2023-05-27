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
        
        do {
            try interpreter.setTreeAST(tree.rootNode)
        } catch let errorType as ErrorType {
            interpreter.setPrintResult(String(describing: errorType))
        } catch {
            interpreter.setPrintResult(String(describing: error))
        }
        
        return interpreter.getPrintResult()
    }
    
}

