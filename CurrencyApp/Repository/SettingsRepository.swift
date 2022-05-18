import Networking
import Combine

protocol SettingsRepositoryProtocol {
    init(fetcher: DataFetcherProtocol)
    
    func fetchSupportedCurrencies() -> AnyPublisher<[Currency], CryptoError>
}

class SettingsRepository: SettingsRepositoryProtocol {
    
    private let fetcher: DataFetcherProtocol
    
    required init(fetcher: DataFetcherProtocol) {
        self.fetcher = fetcher
    }
    
    func fetchSupportedCurrencies() -> AnyPublisher<[Currency], CryptoError> {
        fetcher.fetchSupportedCurrencies()
            .map { $0.map(Currency.init) }
            .eraseToAnyPublisher()
    }
}
