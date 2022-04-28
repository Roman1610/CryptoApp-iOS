import Foundation
import Networking

public struct CoinMarket: Hashable, Identifiable {
    public static func == (lhs: CoinMarket, rhs: CoinMarket) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: String
    public let symbol: String
    public let name: String
    public let image: String
    public let currentPrice: Double
    public let marketCap: Double
    public let high24h: Double?
    public let priceChangePercentage24h: Double?
    
    init(id: String,
         symbol: String,
         name: String,
         image: String,
         currentPrice: Double) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        
        marketCap = 0.0
        high24h = 0.0
        priceChangePercentage24h = 0.0
    }
    
    public init(coinMarket: ResponseCoinMarket) {
        id = coinMarket.id
        symbol = coinMarket.symbol
        name = coinMarket.name
        image = coinMarket.image
        currentPrice = coinMarket.currentPrice
        marketCap = coinMarket.marketCap
        high24h = coinMarket.high24h
        priceChangePercentage24h = coinMarket.priceChangePercentage24h
    }
}
