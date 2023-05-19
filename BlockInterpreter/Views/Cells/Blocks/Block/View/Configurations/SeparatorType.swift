//
//  ConditionSeparatorType.swift
//  BlockInterpreter
//

import Foundation

enum BracketType {
    case open, close
}

enum SeparatorType {
    case bracket(BracketType)
    case semicolon
    
    var title: String {
        switch self {
        case .bracket(.open):
            return "("
        case .bracket(.close):
            return ")"
        case .semicolon:
            return ";"
        }
    }
}
