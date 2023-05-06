//
//  ConditionBlockType.swift
//  BlockInterpreter
//

import Foundation

enum ConditionBlockType: String, CaseIterable {
    case ifStatement, elseStatement
    
    var name: String {
        switch self {
        case .ifStatement:
            return "if"
        case .elseStatement:
            return "else"
        }
    }
}
