import Foundation


struct ResponseCoin: Decodable {
    let id: String
    let symbol: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id, symbol, name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
    }
}
