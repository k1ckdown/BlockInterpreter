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
    let type: ArrayMethodType
    let name: String
    let value: String
    var isDebug: Bool
    
    init(id: Int, type: ArrayMethodType, name: String, value: String, isDebug: Bool) {
        self.type = type
        self.name = name
        self.value = value
        self.isDebug = false
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ArrayMethodType.self, forKey: .type)
        name = try container.decode(String.self, forKey: .name)
        value = try container.decode(String.self, forKey: .value)
        isDebug = try container.decode(Bool.self, forKey: .isDebug)
        
        try super.init(from: decoder)
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
        
        try super.encode(to: encoder)
      }
}

