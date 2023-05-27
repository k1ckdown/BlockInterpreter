//
//  VariableBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class VariableBlockCellViewModel: BlockCellViewModel {
    
    var variableName: String?
    var variableValue: String?
    
    var typeTitle: String? {
        variableType.name
    }
    
    private(set) var variableType: VariableType
    private(set) var blockType: VariableBlockType
    private(set) var variableNamePlaceHolder: String
    private(set) var variableValuePlaceholder: String
    private var allVariableTypes = VariableType.allCases.filter { $0 != .void }
    private var currentTypeIndex = 0
    
    init(blockType: VariableBlockType, variableType: VariableType, style: BlockCellStyle) {
        variableValuePlaceholder = LocalizedStrings.value()
        variableNamePlaceHolder = LocalizedStrings.name()
        self.blockType = blockType
        self.variableType = variableType
        super.init(type: .variable, style: style)
    }
    
    override func copyToWork() -> BlockCellViewModel {
        let copy = VariableBlockCellViewModel(blockType: blockType,
                                              variableType: variableType,
                                              style: .work)
        
        copy.variableName = variableName
        copy.variableValue = variableValue
        
        return copy
    }
    
    func didChangeType() {
        currentTypeIndex += 1
        
        if currentTypeIndex == allVariableTypes.count {
            currentTypeIndex = 0
        }
        
        variableType = allVariableTypes[currentTypeIndex]
    }
    
}
