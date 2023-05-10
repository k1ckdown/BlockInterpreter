//
//  ConditionBlockType.swift
//  BlockInterpreter
//

import Foundation

enum ConditionBlockType: String, CaseIterable {
    case ifStatement, elseIfStatement, elseStatement
    
    var name: String {
        switch self {
        case .ifStatement:
            return "if"
        case .elseIfStatement:
            return "elif"
        case .elseStatement:
            return "else"
        }
    }
}
