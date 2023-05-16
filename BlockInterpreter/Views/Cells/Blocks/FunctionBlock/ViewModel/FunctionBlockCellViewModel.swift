//
//  FunctionBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class FunctionBlockCellViewModel: BlockCellViewModel  {
    
    var functionName: String?
    var argumentsString: String?
    
    var title: String {
        "FUNC"
    }
    
    var loopValue: String {
        "\(functionName ?? "")(\(argumentsString ?? ""))"
    }
    
    init(style: BlockCellStyle) {
        super.init(type: .function, style: style)
    }
    
    override func copyToWork() -> FunctionBlockCellViewModel {
        let copy = FunctionBlockCellViewModel(style: .work)
        
        copy.functionName = functionName
        copy.argumentsString = argumentsString
        
        return copy
    }
}
