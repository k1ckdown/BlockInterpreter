import Foundation


enum VariableType: String, CaseIterable, Codable {
    case int
    case double
    case string
    case bool
    case void
    case arrayInt
    case arrayBool
    case arrayDouble
    case arrayString
    
    var name: String {
        switch self {
        case .int, .double, .bool, .string, .void:
            return self.rawValue.capitalized
        case .arrayInt:
                return "Int[]"
        case .arrayDouble:
            return "Double[]"
        case .arrayString:
            return "String[]"
        case .arrayBool:
            return "Bool[]"
        }
    }
}


class Variable: IBlock {
    let type: VariableType
    let name: String
    let value: String
    var isDebug: Bool
    
    init(id: Int, type: VariableType, name: String, value: String) {
        self.type = type
        self.name = name
        self.value = value
        isDebug = false
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(VariableType.self, forKey: .type)
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

