//
//  WhileLoopBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class WhileLoopBlockCellViewModel: LabelTFBlockCellViewModel {
    
    private(set) var loopType: LoopType
    
    init(style: BlockCellStyle) {
        loopType = .whileLoop
        super.init(title: "while", placeholder: "condition", type: .loop(.whileLoop), style: style)
    }
    
    override func copyToWork() -> WhileLoopBlockCellViewModel {
        let copy = WhileLoopBlockCellViewModel(style: .work)
        copy.text = text
        
        return copy
    }
    
}

