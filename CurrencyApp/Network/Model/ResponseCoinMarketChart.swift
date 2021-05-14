import Foundation


struct ResponseCoinMarketChartData {
    let prices: [ResponseCoinMarketChartNode]
    
    init(from string: String, type: String) {
        debugPrint("ResponseCoinMarketChartData: string - \(string)")
        var prices = [ResponseCoinMarketChartNode]()
        if let obj = try? JSONSerialization.jsonObject(with: string.data(using: .utf8)!) as? [String: Any],
           let pricesObj = obj[type] as? [[Double]] {
            debugPrint("ResponseCoinMarketChartData: prices - \(pricesObj)")
            for item in pricesObj {
                prices.append(ResponseCoinMarketChartNode(timestamp: Int64(item[0]), price: item[1]))
            }
        }
        
        self.prices = prices
    }
}


struct ResponseCoinMarketChartNode {
    let timestamp: Int64
    let price: Double
    
    init(timestamp: Int64, price: Double) {
        self.timestamp = timestamp
        self.price = price
    }
}
