//
//  OutputBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class OutputBlockCellViewModel: LabelTFBlockCellViewModel {
    
    init(style: BlockCellStyle) {
        super.init(title: "print", placeholder: "output", type: .output, style: style)
    }
    
    override func copyToWork() -> OutputBlockCellViewModel {
        let copy = OutputBlockCellViewModel(style: .work)
        copy.text = text
        
        return copy
    }
    
}
