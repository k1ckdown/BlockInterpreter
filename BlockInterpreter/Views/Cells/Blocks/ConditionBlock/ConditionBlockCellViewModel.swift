//
//  ConditionBlockCellViewModel.swift
//  BlockInterpreter
//

import Foundation

final class ConditionBlockCellViewModel: BlockCellViewModel {
    
    private(set) var conditionStatement: String
    private(set) var conditionTextPlaceholder: String
    private(set) var shouldShowConditionField: Bool
    
    init(conditionBlockType: ConditionBlockType) {
        conditionTextPlaceholder = "condition"
        conditionStatement = conditionBlockType.name.uppercased()
        shouldShowConditionField = conditionBlockType != .elseStatement
    }
    
}
