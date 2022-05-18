import Foundation
import Networking
import Combine

protocol MainRepositoryProtocol {
    init(fetcher: DataFetcherProtocol)
    
    func fetchAllData() -> AnyPublisher<[Coin], CryptoError>
    func fetchCoinMarkets(page: Int,
                          currency: String,
                          order: GeckoSortResultEnum?,
                          perPage: Int) -> AnyPublisher<[CoinMarket], CryptoError>
}

extension MainRepositoryProtocol {
    
    func fetchCoinMarkets(page: Int, currency: String) -> AnyPublisher<[CoinMarket], CryptoError> {
        fetchCoinMarkets(page: page, currency: currency, order: nil, perPage: 50)
    }
}

class MainRepository: MainRepositoryProtocol {
    
    private let fetcher: DataFetcherProtocol
    
    required init(fetcher: DataFetcherProtocol) {
        self.fetcher = fetcher
    }
    
    func fetchAllData() -> AnyPublisher<[Coin], CryptoError> {
        fetcher.fetchAllCoins()
            .map { $0.map(Coin.init) }
            .eraseToAnyPublisher()
    }
    
    func fetchCoinMarkets(page: Int,
                          currency: String,
                          order: GeckoSortResultEnum? = nil,
                          perPage: Int = 50) -> AnyPublisher<[CoinMarket], CryptoError> {
        fetcher.fetchCoinMarkets(page: page, currency: currency, order: order, perPage: perPage)
            .map {
                $0.map(CoinMarket.init)
            }
            .eraseToAnyPublisher()
    }
}
