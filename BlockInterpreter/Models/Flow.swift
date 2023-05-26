import Foundation

enum FlowType: CaseIterable, Codable {
    case begin
    case end
    case continueCondition
    case breakCondition
}

class Flow: IBlock {
    let id: Int
    let type: FlowType
    
    init(id: Int, type: FlowType) {
        self.id = id
        self.type = type
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
      }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
      }
}


