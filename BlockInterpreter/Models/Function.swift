import Foundation


class Function: IBlock {
    let value: String
    let name: String
    let type: VariableType
    var isDebug: Bool
    
    init(id: Int, value: String, name: String, type: VariableType) {
        self.value = value
        self.name = name
        self.type = type
        isDebug = false
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(VariableType.self, forKey: .type)
        isDebug = try container.decode(Bool.self, forKey: .isDebug)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case value
        case name
        case type
        case isDebug
      }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(value, forKey: .value)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        
        try super.encode(to: encoder)
      }
}
