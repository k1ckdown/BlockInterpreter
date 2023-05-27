import Foundation


class Returning: IBlock {
    let value: String
    var isDebug: Bool
    
    init(id: Int, value: String) {
        self.value = value
        isDebug = false
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        isDebug = try container.decode(Bool.self, forKey: .isDebug)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case value
        case isDebug
      }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        
        try super.encode(to: encoder)
      }
}
