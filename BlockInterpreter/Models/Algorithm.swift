//
//  Algorithm.swift
//  BlockInterpreter
//

import Foundation

class Algorithm: Codable {
    let name: String
    let imageData: Data
    
    private var returns = [Returning]()
    private var functions = [Function]()
    private var variables = [Variable]()
    private var conditions = [Condition]()
    private var outputs = [Output]()
    private var flows = [Flow]()
    private var loops = [Loop]()
    private var arrayMethods = [ArrayMethod]()
    
    init(name: String, imageData: Data, blocks: [IBlock]) {
        self.name = name
        self.imageData = imageData
        setBlocks(blocks)
    }
    
    func setBlocks(_ blocks: [IBlock]) {
        for block in blocks {
            switch block {
            case let block as Returning:
                returns.append(block)
            case let block as Function:
                functions.append(block)
            case let block as Variable:
                variables.append(block)
            case let block as Condition:
                conditions.append(block)
            case let block as Output:
                outputs.append(block)
            case let block as Flow:
                flows.append(block)
            case let block as Loop:
                loops.append(block)
            case let block as ArrayMethod:
                arrayMethods.append(block)
            default: continue
            }
        }
    }
    
    func getBlocks() -> [IBlock] {
        let blocks = returns + functions + variables
        return blocks
    }
    
}
