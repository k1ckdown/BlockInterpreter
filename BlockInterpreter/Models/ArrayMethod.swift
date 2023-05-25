//
//  ArrayMethod.swift
//  BlockInterpreter
//

import Foundation


enum ArrayMethodType: String, CaseIterable {
    case append
    case remove
    case pop
}

struct ArrayMethod: IBlock {
    let id: Int
    let type: ArrayMethodType
    let name: String
    let value: String
    let isDebug: Bool
}

