import Foundation


protocol CoinDetailRepositoryProtocol {
    init(fetcher: DataFetcherProtocol)
    
    func fetchCoinChart(id: String, currency: String, days: Int, result: @escaping ([ResponseCoinMarketChartNode]) -> ())
    func fetchCoinChartRange(id: String, currency: String, from: Int, to: Int, result: @escaping ([ResponseCoinMarketChartNode]) -> ())
}

class CoinDetailRepository: CoinDetailRepositoryProtocol {
    
    private let fetcher: DataFetcherProtocol
    
    required init(fetcher: DataFetcherProtocol) {
        self.fetcher = fetcher
    }
    
    func fetchCoinChart(id: String, currency: String, days: Int, result: @escaping ([ResponseCoinMarketChartNode]) -> ()) {
        fetcher.fetchCoinMarketChart(id: id, currency: currency, days: days) { responseData in
            result(responseData.prices)
        }
    }
    
    func fetchCoinChartRange(id: String, currency: String, from: Int, to: Int, result: @escaping ([ResponseCoinMarketChartNode]) -> ()) {
        fetcher.fetchCoinMarketChartRange(id: id, currency: currency, from: from, to: to) { responseData in
            result(responseData.prices)
        }
    }
    
}
