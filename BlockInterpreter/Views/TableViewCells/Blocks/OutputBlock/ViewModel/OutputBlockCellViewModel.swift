//
//  OutputBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class OutputBlockCellViewModel: BlockCellViewModel {
    
    var outputValue: String?
    
    var title: String {
        outputType.rawValue.uppercased()
    }
    
    private(set) var outputType: OutputType
    private(set) var placeholder: String
    
    init(outputType: OutputType, style: BlockCellStyle) {
        self.outputType = outputType
        placeholder = "output"
        super.init(type: .output, style: style)
    }
    
    override func copyToWork() -> OutputBlockCellViewModel {
        let copy = OutputBlockCellViewModel(outputType: outputType, style: .work)
        copy.outputValue = outputValue
        
        return copy
    }
    
}
