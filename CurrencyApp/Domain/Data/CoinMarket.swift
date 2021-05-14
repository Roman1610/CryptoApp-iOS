import Foundation


struct CoinMarket: Hashable, Identifiable {
    static func == (lhs: CoinMarket, rhs: CoinMarket) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double
    let high24h: Double?
    let priceChangePercentage24h: Double?
    
    init(id: String,
        symbol: String,
        name: String,
        image: String,
        currentPrice: Double
    ) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        
        marketCap = 0.0
        high24h = 0.0
        priceChangePercentage24h = 0.0
    }
    
    init(coinMarket: ResponseCoinMarket) {
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
    
