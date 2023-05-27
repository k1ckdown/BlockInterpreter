//
//  FunctionBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class FunctionBlockCellViewModel: BlockCellViewModel  {
    
    var functionName: String?
    var argumentsString: String?
    
    var typeTitle: String? {
        returnType.name
    }
    
    var loopValue: String {
        "\(functionName ?? "")(\(argumentsString ?? ""))"
    }
    
    private(set) var title = LocalizedStrings.funcTitle()
    private var returnType: VariableType
    private var allVariableTypes = VariableType.allCases
    private var currentTypeIndex = 0
    
    init(returnType: VariableType, style: BlockCellStyle) {
        self.returnType = returnType
        super.init(type: .function, style: style)
    }
    
    override func copyToWork() -> FunctionBlockCellViewModel {
        let copy = FunctionBlockCellViewModel(returnType: returnType, style: .work)
        
        copy.functionName = functionName
        copy.argumentsString = argumentsString
        
        return copy
    }
    
    func didChangeType() {
        currentTypeIndex += 1
        
        if currentTypeIndex == allVariableTypes.count {
            currentTypeIndex = 0
        }
        
        returnType = allVariableTypes[currentTypeIndex]
    }
}
