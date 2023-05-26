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
    let id: Int
    let type: LoopType
    let value: String
    
    init(id: Int, type: LoopType, value: String) {
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
