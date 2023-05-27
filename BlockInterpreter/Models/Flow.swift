import Foundation

enum FlowType: CaseIterable, Codable {
    case begin
    case end
    case continueFlow
    case breakFlow
}

class Flow: IBlock {
    let type: FlowType
    var isDebug: Bool
    
    init(id: Int, type: FlowType) {
        self.type = type
        isDebug = false
        super.init(id: id)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case isDebug
      }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(FlowType.self, forKey: .type)
        isDebug = try container.decode(Bool.self, forKey: .isDebug)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        
        try super.encode(to: encoder)
      }
}


