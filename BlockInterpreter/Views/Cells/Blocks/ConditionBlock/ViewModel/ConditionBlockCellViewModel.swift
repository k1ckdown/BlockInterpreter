//
//  ConditionBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class ConditionBlockCellViewModel: BlockCellViewModel {
    
    private(set) var conditionStatement: String
    private(set) var conditionTextPlaceholder: String
    private(set) var shouldShowConditionField: Bool
    private let conditionBlockType: ConditionBlockType
    
    init(conditionBlockType: ConditionBlockType, style: BlockCellStyle) {
        conditionTextPlaceholder = "condition"
        conditionStatement = conditionBlockType.name.uppercased()
        shouldShowConditionField = conditionBlockType != .elseStatement
        self.conditionBlockType = conditionBlockType
        super.init(type: .condition, style: style)
    }
    
    override func copyToWork() -> BlockCellViewModel {
        return ConditionBlockCellViewModel(conditionBlockType: conditionBlockType, style: .work)
    }
    
}
