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
        
        do {
            try interpreter.setTreeAST(tree.rootNode)
        } catch let errorType as ErrorType {
            interpreter.setPrintResult(String(describing: errorType))
        } catch {
            interpreter.setPrintResult(String(describing: error))
        }
        
        let result = interpreter.getPrintResult()
        
        return result

    }
    
}

