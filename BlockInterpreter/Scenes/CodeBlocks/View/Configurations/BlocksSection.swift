//
//  BlocksSection.swift
//  BlockInterpreter
//

import Foundation

enum BlocksSection: Int, CaseIterable {
    case variables, conditions, loops, arrays, functions
    
    var heightForRow: CGFloat {
        return 90
    }
    
    var title: String {
        switch self {
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
