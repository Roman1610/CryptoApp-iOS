import Foundation

public struct ResponseCoinMarket: Decodable {
    public let id: String
    public let symbol: String
    public let name: String
    public let image: String
    public let currentPrice: Double
    public let marketCap: Double
    public let marketCapRank: Int
    public let fullyDilutedValuation: Int64?
    public let totalVolume: Double
    public let high24h: Double?
    public let low24h: Double?
    public let priceChange24h: Double?
    public let priceChangePercentage24h: Double?
    public let marketCapChange24h: Double?
    public let marketCapChangePercentage24h: Double?
    public let circulatingSupply: Double?
    public let totalSupply: Double?
    public let maxSupply: Double?
    public let ath: Double
    public let athChangePercentage: Double
    public let athDate: String
    public let atl: Double
    public let atlChangePercentage: Double
    public let atlDate: String
    public let roi: ResponseCoinRoi?
    public let lastUpdated: String
    
    private enum CodingKeys: String, CodingKey {
        case id, symbol, name, image, current_price, market_cap, market_cap_rank, fully_diluted_valuation, total_volume, high_24h, low_24h, price_change_24h, price_change_percentage_24h, market_cap_change_24h, market_cap_change_percentage_24h, circulating_supply, total_supply, max_supply, ath, ath_change_percentage, ath_date, atl, atl_change_percentage, atl_date, roi, last_updated
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(String.self, forKey: .image)
        currentPrice = try container.decode(Double.self, forKey: .current_price)
        marketCap = try container.decode(Double.self, forKey: .market_cap)
        marketCapRank = try container.decode(Int.self, forKey: .market_cap_rank)
        fullyDilutedValuation = try? container.decode(Int64.self, forKey: .fully_diluted_valuation)
        totalVolume = try container.decode(Double.self, forKey: .total_volume)
        high24h = try? container.decode(Double.self, forKey: .high_24h)
        low24h = try? container.decode(Double.self, forKey: .low_24h)
        priceChange24h = try? container.decode(Double.self, forKey: .price_change_24h)
        priceChangePercentage24h = try? container.decode(Double.self, forKey: .price_change_percentage_24h)
        marketCapChange24h = try? container.decode(Double.self, forKey: .market_cap_change_24h)
        marketCapChangePercentage24h = try? container.decode(Double.self, forKey: .market_cap_change_percentage_24h)
        circulatingSupply = try container.decode(Double.self, forKey: .circulating_supply)
        totalSupply = try? container.decode(Double.self, forKey: .total_supply)
        maxSupply = try? container.decode(Double.self, forKey: .max_supply)
        ath = try container.decode(Double.self, forKey: .ath)
        athChangePercentage = try container.decode(Double.self, forKey: .ath_change_percentage)
        athDate = try container.decode(String.self, forKey: .ath_date)
        atl = try container.decode(Double.self, forKey: .atl)
        atlChangePercentage = try container.decode(Double.self, forKey: .atl_change_percentage)
        atlDate = try container.decode(String.self, forKey: .atl_date)
        roi = try? container.decode(ResponseCoinRoi.self, forKey: .roi)
        lastUpdated = try container.decode(String.self, forKey: .last_updated)
    }
}


public struct ResponseCoinRoi: Decodable {
    public let times: Double
    public let currency: String
    public let percentage: Double
    
    private enum CodingKeys: String, CodingKey {
        case times, currency, percentage
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        times = try container.decode(Double.self, forKey: .times)
        currency = try container.decode(String.self, forKey: .currency)
        percentage = try container.decode(Double.self, forKey: .percentage)
    }
}
