//
//  VariableBlockType.swift
//  BlockInterpreter
//

import Foundation

enum VariableBlockType: CaseIterable {
//    case initial
    case initialAssignment
    case assignment
    
    var defaultType: VariableType {
        switch self {
        case .initialAssignment:
            return .int
        case .assignment:
            return .void
        }
    }
}
