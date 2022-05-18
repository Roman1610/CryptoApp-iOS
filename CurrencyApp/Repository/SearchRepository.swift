import Networking
import Combine

protocol SearchRepositoryProtocol {
    init(fetcher: DataFetcherProtocol)
    
    func fetchCoinMarkets(page: Int,
                          currency: String,
                          order: GeckoSortResultEnum?,
                          perPage: Int) -> AnyPublisher<[CoinMarket], CryptoError>
}

extension SearchRepositoryProtocol {
    
    func fetchCoinMarkets(page: Int, currency: String) -> AnyPublisher<[CoinMarket], CryptoError> {
        fetchCoinMarkets(page: page, currency: currency, order: nil, perPage: 50)
    }
}

class SearchRepository: SearchRepositoryProtocol {
    
    private let fetcher: DataFetcherProtocol
    
    required init(fetcher: DataFetcherProtocol) {
        self.fetcher = fetcher
    }
    
    func fetchCoinMarkets(page: Int,
                          currency: String,
                          order: GeckoSortResultEnum? = nil,
                          perPage: Int) -> AnyPublisher<[CoinMarket], CryptoError> {
        fetcher.fetchCoinMarkets(page: page, currency: currency, order: order, perPage: perPage)
            .map { $0.map(CoinMarket.init) }
            .eraseToAnyPublisher()
    }
}
