import Foundation


enum LoopType: Codable {
    case forLoop, whileLoop
    
    var name: String {
        switch self {
        case .forLoop:
            return "for"
        case .whileLoop:
            return "while"
        }
    }
}


class Loop: IBlock {
    let type: LoopType
    let value: String
    
    init(id: Int, type: LoopType, value: String) {
        self.type = type
        self.value = value
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(LoopType.self, forKey: .type)
        value = try container.decode(String.self, forKey: .value)
        
        try super.init(from: decoder)
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
        
        try super.encode(to: encoder)
      }
}
