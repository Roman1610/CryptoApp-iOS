import Foundation

public struct ResponseCoinMarketChartData {
    
    public let prices: [ResponseCoinMarketChartNode]
    
    init(from string: String, type: String) {
        var prices = [ResponseCoinMarketChartNode]()
        if let obj = try? JSONSerialization.jsonObject(with: string.data(using: .utf8)!) as? [String: Any],
           let pricesObj = obj[type] as? [[Double]] {
            for item in pricesObj {
                prices.append(ResponseCoinMarketChartNode(timestamp: Int64(item[0]), price: item[1]))
            }
        }
        
        self.prices = prices
    }
}

public struct ResponseCoinMarketChartNode {
    public let timestamp: Int64
    public let price: Double
    
    init(timestamp: Int64, price: Double) {
        self.timestamp = timestamp
        self.price = price
    }
}
