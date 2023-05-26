//
//  WhileLoopBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class WhileLoopBlockCellViewModel: BlockCellViewModel {
    
    var loopCondition: String?
    
    private(set) var loopType: LoopType
    private(set) var title: String
    private(set) var placeholder: String
    
    init(style: BlockCellStyle) {
        loopType = .whileLoop
        title = "WHILE"
        placeholder = "condition"
        super.init(type: .loop(.whileLoop), style: style)
    }
    
    override func copyToWork() -> WhileLoopBlockCellViewModel {
        let copy = WhileLoopBlockCellViewModel(style: .work)
        copy.loopCondition = loopCondition
        
        return copy
    }
    
}

