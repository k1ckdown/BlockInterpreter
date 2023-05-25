//
//  BlocksSection.swift
//  BlockInterpreter
//

import Foundation

enum BlocksSection: Int, CaseIterable {
    case output
    case commonFlow
    case variables
    case conditions
    case conditionFlow
    case loops
    case functions
    case arrayMethods
    
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
        case .arrayMethods:
            return "Array Methods"
        }
    }
}
