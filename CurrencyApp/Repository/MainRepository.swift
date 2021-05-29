import Foundation


protocol MainRepositoryProtocol {
    init(fetcher: DataFetcherProtocol)
    
    func fetchAllData(result: @escaping ([Coin]) -> ())
    func fetchCoinMarkets(page: Int, currency: String, order: GeckoSortResultEnum?, perPage: Int, result: @escaping ([CoinMarket]) -> ())
}

extension MainRepositoryProtocol {
    func fetchCoinMarkets(page: Int, currency: String, result: @escaping ([CoinMarket]) -> ()) {
        fetchCoinMarkets(page: page, currency: currency, order: nil, perPage: 50, result: result)
    }
}

class MainRepository: MainRepositoryProtocol {
    
    private let fetcher: DataFetcherProtocol
    
    required init(fetcher: DataFetcherProtocol) {
        self.fetcher = fetcher
    }
    
    func fetchAllData(result: @escaping ([Coin]) -> ()) {
        fetcher.fetchAllCoins { coinsData in
            result(coinsData.map(Coin.init))
        }
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
