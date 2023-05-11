//
//  ConditionBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class ConditionBlockCellViewModel: BlockCellViewModel {
    
    var conditionText: String?
    
    private(set) var conditionStatement: String
    private(set) var conditionTextPlaceholder: String
    private(set) var shouldShowConditionField: Bool
    private(set) var conditionType: ConditionType
    
    init(conditionType: ConditionType, style: BlockCellStyle) {
        conditionTextPlaceholder = "condition"
        conditionStatement = conditionType.name.uppercased()
        shouldShowConditionField = conditionType != .elseBlock
        self.conditionType = conditionType
        super.init(type: .condition, style: style)
    }
    
    override func copyToWork() -> BlockCellViewModel {
        let copy = ConditionBlockCellViewModel(conditionType: conditionType, style: .work)
        copy.conditionText = conditionText
        
        return copy
    }
    
}
