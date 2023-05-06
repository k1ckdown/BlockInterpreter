//
//  VariableBlockType.swift
//  BlockInterpreter
//

import Foundation

enum VariableBlockType: CaseIterable {
    case initial, assignment
    
    var defaultType: VariableType? {
        switch self {
        case .initial:
            return .int
        case .assignment:
            return nil
        }
    }
}
