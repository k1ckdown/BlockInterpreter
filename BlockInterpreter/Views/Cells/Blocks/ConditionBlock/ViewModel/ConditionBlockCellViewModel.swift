//
//  ConditionBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class ConditionBlockCellViewModel: BlockCellViewModel {
    
    var conditionText: String?
    
    var conditionStatement: String {
        return conditionType.name.uppercased()
    }
    
    var shouldShowConditionField: Bool {
        return conditionType != .elseBlock
    }
    
    private(set) var conditionTextPlaceholder: String
    private(set) var conditionType: ConditionType
    
    init(conditionType: ConditionType, style: BlockCellStyle) {
        conditionTextPlaceholder = "condition"
        self.conditionType = conditionType
        super.init(type: .condition, style: style)
    }
    
    override func copyToWork() -> BlockCellViewModel {
        let copy = ConditionBlockCellViewModel(conditionType: conditionType, style: .work)
        copy.conditionText = conditionText
        
        return copy
    }
    
}
