//
//  FlowBlockStyle.swift
//  BlockInterpreter
//

import UIKit

enum FlowBlockStyle: String {
    case begin, end, continueСondition, breakCondition
    
    var title: String {
        switch self {
        case .begin, .end:
            return self.rawValue.uppercased()
        case .continueСondition:
            return "CONTINUE"
        case .breakCondition:
            return "BREAK"
        }
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .begin:
            return .beginBlock
        case .end:
            return .endBlock
        case .continueСondition:
            return .systemGreen
        case .breakCondition:
            return .breakBlock
        }
    }
}
