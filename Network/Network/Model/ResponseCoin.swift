import Foundation

public struct ResponseCoin: Decodable {
    public let id: String
    public let symbol: String
    public let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id, symbol, name
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
    }
}
