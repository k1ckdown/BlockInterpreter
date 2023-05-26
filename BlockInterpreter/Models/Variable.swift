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
    let id: Int
    let type: VariableType
    let name: String
    let value: String
    
    init(id: Int, type: VariableType, name: String, value: String) {
        self.id = id
        self.type = type
        self.name = name
        self.value = value
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
      }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
      }
}

