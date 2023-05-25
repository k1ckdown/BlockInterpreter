//
//  BlocksSection.swift
//  BlockInterpreter
//

import Foundation

enum BlocksSection: Int, CaseIterable {
    case output, commonFlow, variables, conditions, conditionFlow, loops, functions
    
    var heightForRow: CGFloat {
        return 90
    }
    
    var title: String {
        switch self {
        case .output:
            return "Output"
        case .commonFlow:
            return "Common Flow"
        case .variables:
            return "Variables"
        case .conditions:
            return "Conditions"
        case .conditionFlow:
            return "Condition Flow"
        case .loops:
            return "Loops"
        case .functions:
            return "Functions"
        }
    }
}
