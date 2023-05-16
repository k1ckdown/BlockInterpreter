//
//  ConditionSeparatorType.swift
//  BlockInterpreter
//
//  Created by Ivan Semenov on 16.05.2023.
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
