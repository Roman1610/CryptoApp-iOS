import Networking
import Combine

protocol CoinDetailRepositoryProtocol {
    
    init(fetcher: DataFetcherProtocol)
    
    func fetchCoinChart(id: String,
                        currency: String,
                        days: Int) -> AnyPublisher<[ResponseCoinMarketChartNode], CryptoError>
    func fetchCoinChartRange(id: String,
                             currency: String,
                             from: Int,
                             to: Int) -> AnyPublisher<[ResponseCoinMarketChartNode], CryptoError>
}

class CoinDetailRepository: CoinDetailRepositoryProtocol {
    
    private let fetcher: DataFetcherProtocol
    
    required init(fetcher: DataFetcherProtocol) {
        self.fetcher = fetcher
    }
    
    func fetchCoinChart(id: String,
                        currency: String,
                        days: Int) -> AnyPublisher<[ResponseCoinMarketChartNode], CryptoError> {
        fetcher.fetchCoinMarketChart(id: id, currency: currency, days: days)
            .map { $0.prices }
            .eraseToAnyPublisher()
    }
    
    func fetchCoinChartRange(id: String,
                             currency: String,
                             from: Int,
                             to: Int) -> AnyPublisher<[ResponseCoinMarketChartNode], CryptoError> {
        fetcher.fetchCoinMarketChartRange(id: id, currency: currency, from: from, to: to)
            .map { $0.prices }
            .eraseToAnyPublisher()
    }
    
}
