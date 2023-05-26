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
    let id: Int
    let type: ConditionType
    let value: String
    
    init(id: Int, type: ConditionType, value: String) {
        self.id = id
        self.type = type
        self.value = value
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case value
      }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
      }
}

