//
//  LoopBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class LoopBlockCellViewModel: LabelTFBlockCellViewModel {
    
    init(style: BlockCellStyle) {
        super.init(title: "while", placeholder: "condition", type: .loop, style: style)
    }
    
    override func copyToWork() -> LoopBlockCellViewModel {
        let copy = LoopBlockCellViewModel(style: .work)
        copy.text = text
        
        return copy
    }
    
}

