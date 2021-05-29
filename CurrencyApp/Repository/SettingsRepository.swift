import Foundation


protocol SettingsRepositoryProtocol {
    init(fetcher: DataFetcherProtocol)
    
    func fetchSupportedCurrencies(result: @escaping ([Currency]) -> ())
}

class SettingsRepository: SettingsRepositoryProtocol {
    
    private let fetcher: DataFetcherProtocol
    
    required init(fetcher: DataFetcherProtocol) {
        self.fetcher = fetcher
    }
    
    func fetchSupportedCurrencies(result: @escaping ([Currency]) -> ()) {
        fetcher.fetchSupportedCurrencies { currenciesData in
            result(currenciesData.map(Currency.init))
        }
    }
}
