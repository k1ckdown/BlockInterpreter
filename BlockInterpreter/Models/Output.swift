import Foundation

enum OutputType: String, CaseIterable, Codable {
    case print
    case println
}

class Output: IBlock {
    let value: String
    let type: OutputType
    
    init(id: Int, type: OutputType, value: String) {
        self.type = type
        self.value = value
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        type = try container.decode(OutputType.self, forKey: .type)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case value
        case type
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(value, forKey: .value)
        try container.encode(type, forKey: .type)
        
        try super.encode(to: encoder)
      }
}
