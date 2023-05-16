//
//  BlocksSection.swift
//  BlockInterpreter
//

import Foundation

enum BlocksSection: Int, CaseIterable {
    case output, flow, variables, conditions, loops, functions
    
    var heightForRow: CGFloat {
        return 90
    }
    
    var title: String {
        switch self {
        case .output:
            return "Output"
        case .flow:
            return "Flow"
        case .variables:
            return "Variables"
        case .conditions:
            return "Conditions"
        case .loops:
            return "Loops"
        case .functions:
            return "Functions"
        }
    }
}
