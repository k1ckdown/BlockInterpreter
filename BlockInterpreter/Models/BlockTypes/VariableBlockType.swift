//
//  VariableBlockType.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 04.05.2023.
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
