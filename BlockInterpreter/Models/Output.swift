import Foundation

enum OutputType: String, CaseIterable, Codable {
    case print
}

class Output: IBlock {
    let value: String
    let type: OutputType
    var isDebug: Bool
    
    init(id: Int, type: OutputType, value: String) {
        self.type = type
        self.value = value
        isDebug = false
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        type = try container.decode(OutputType.self, forKey: .type)
        isDebug = try container.decode(Bool.self, forKey: .isDebug)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case value
        case type
        case isDebug
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(value, forKey: .value)
        try container.encode(type, forKey: .type)
        
        try super.encode(to: encoder)
      }
}
