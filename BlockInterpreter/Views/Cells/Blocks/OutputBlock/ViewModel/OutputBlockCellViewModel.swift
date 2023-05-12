//
//  OutputBlockCellViewModel.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 11.05.2023.
//

import Foundation

final class OutputBlockCellViewModel: BlockCellViewModel {
    
    var outputText: String?
    private(set) var outputPlaceholder: String
    
    init(style: BlockCellStyle) {
        outputPlaceholder = "output"
        super.init(type: .output, style: style)
    }
    
    override func copyToWork() -> OutputBlockCellViewModel {
        let copy = OutputBlockCellViewModel(style: .work)
        copy.outputText = outputText
        
        return copy
    }
    
}
