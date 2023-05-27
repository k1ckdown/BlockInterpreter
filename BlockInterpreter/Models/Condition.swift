import Foundation


enum ConditionType: String, CaseIterable, Codable {
    case ifBlock, elifBlock, elseBlock
    
    var name: String {
        switch self {
        case .ifBlock:
            return "if"
        case .elifBlock:
            return "elif"
        case .elseBlock:
            return "else"
        }
    }
}


class Condition: IBlock {
    let type: ConditionType
    let value: String
    var isDebug: Bool
    
    init(id: Int, type: ConditionType, value: String) {
        self.type = type
        self.value = value
        isDebug = false
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ConditionType.self, forKey: .type)
        value = try container.decode(String.self, forKey: .value)
        isDebug = try container.decode(Bool.self, forKey: .isDebug)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case isDebug
        case value
      }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
        
        try super.encode(to: encoder)
      }
}

