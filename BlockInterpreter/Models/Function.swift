import Foundation


class Function: IBlock {
    let value: String
    
    init(id: Int, value: String) {
        self.value = value
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case value
      }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(value, forKey: .value)
        
        try super.encode(to: encoder)
      }
}
