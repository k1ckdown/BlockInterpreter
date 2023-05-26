//
//  ArrayMethod.swift
//  BlockInterpreter
//

import Foundation


enum ArrayMethodType: String, CaseIterable, Codable {
    case append
    case remove
    case pop
}

class ArrayMethod: IBlock {
    let id: Int
    let type: ArrayMethodType
    let name: String
    let value: String
    let isDebug: Bool
    
    init(id: Int, type: ArrayMethodType, name: String, value: String, isDebug: Bool) {
        self.id = id
        self.type = type
        self.name = name
        self.value = value
        self.isDebug = isDebug
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case value
        case isDebug
      }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
        try container.encode(isDebug, forKey: .isDebug)
      }
}

