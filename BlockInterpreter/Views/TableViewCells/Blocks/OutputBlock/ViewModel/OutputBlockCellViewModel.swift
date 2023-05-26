//
//  OutputBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class OutputBlockCellViewModel: BlockCellViewModel {
    
    var outputValue: String?
    
    private(set) var title: String
    private(set) var placeholder: String
    
    init(style: BlockCellStyle) {
        title = "PRINT"
        placeholder = "output"
        super.init(type: .output, style: style)
    }
    
    override func copyToWork() -> OutputBlockCellViewModel {
        let copy = OutputBlockCellViewModel(style: .work)
        copy.outputValue = outputValue
        
        return copy
    }
    
}
