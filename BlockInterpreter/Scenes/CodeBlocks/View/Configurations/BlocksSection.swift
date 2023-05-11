//
//  BlocksSection.swift
//  BlockInterpreter
//

import Foundation

enum BlocksSection: Int, CaseIterable {
    case output, variables, conditions, loops, arrays, functions
    
    var heightForRow: CGFloat {
        return 90
    }
    
    var title: String {
        switch self {
        case .output:
            return "Output"
        case .variables:
            return "Variables"
        case .conditions:
            return "Conditions"
        case .loops:
            return "Loops"
        case .arrays:
            return "Arrays"
        case .functions:
            return "Functions"
        }
    }
}
