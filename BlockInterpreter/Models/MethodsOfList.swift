//
//  MethodsOfList.swift
//  BlockInterpreter
//

import Foundation


enum MethodsOfListType: String, CaseIterable {
    case append
    case remove
    case pop
}

struct MethodsOfList: IBlock {
    let id: Int
    let type: MethodsOfListType
    let name: String
    let value: String
    let isDebug: Bool
}

