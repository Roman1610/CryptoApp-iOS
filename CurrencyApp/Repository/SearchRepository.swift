import Foundation


protocol SearchRepositoryProtocol {
    init(fetcher: DataFetcherProtocol)
    
    func fetchCoinMarkets(page: Int, currency: String, order: GeckoSortResultEnum?, perPage: Int, result: @escaping ([CoinMarket]) -> ())
}

extension SearchRepositoryProtocol {
    func fetchCoinMarkets(page: Int, currency: String, result: @escaping ([CoinMarket]) -> ()) {
        fetchCoinMarkets(page: page, currency: currency, order: nil, perPage: 50, result: result)
    }
}

class SearchRepository: SearchRepositoryProtocol {
    
    private let fetcher: DataFetcherProtocol
    
    required init(fetcher: DataFetcherProtocol) {
        self.fetcher = fetcher
    }
    
    func fetchCoinMarkets(
        page: Int,
        currency: String,
        order: GeckoSortResultEnum? = nil,
        perPage: Int,
        result: @escaping ([CoinMarket]) -> ()
    ) {
        fetcher.fetchCoinMarkets(page: page, currency: currency, order: order, perPage: perPage) { responseCoinMarkets in
            result(responseCoinMarkets.map(CoinMarket.init))
        }
    }
}
