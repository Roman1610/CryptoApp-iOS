import Foundation
import Combine
import Networking

final class MainViewModel: ObservableObject {
    
    @Published private(set) var coinMarkets = [CoinMarket]()
    @Published private(set) var error: CryptoError?
    
    @Published private(set) var isInitialLoading = false
    @Published private(set) var isLoadingPage = false
    
    private var currentCurrency: String
    
    private var currentLoadedPages = 0
    private let repository: MainRepositoryProtocol
    private var cancellable = Set<AnyCancellable>()
    
    deinit {
        cancellable.forEach { $0.cancel() }
    }
    
    required init(fetcher: DataFetcherProtocol) {
        repository = MainRepository(fetcher: fetcher)
        currentCurrency = UserDefaults.currency
        UserDefaults.$currency.sink {
            [weak self] newValue in
            
            self?.currentCurrency = newValue
            self?.refreshCoinMarkets()
        }.store(in: &cancellable)
    }
    
    func loadData() {
        loadCoinMarkets()
    }
    
    func refreshCoinMarkets() {
        currentLoadedPages = 0
        coinMarkets.removeAll()
        loadCoinMarkets()
    }
    
    func loadMore() {
        currentLoadedPages += 1
        loadCoinMarkets()
    }
    
    private func loadCoinMarkets() {
        guard !isLoadingPage && !isInitialLoading else {
            return
        }

        if currentLoadedPages == 0 {
            isInitialLoading = true
        } else {
            isLoadingPage = true
        }
        
        repository.fetchCoinMarkets(page: currentLoadedPages + 1, currency: currentCurrency)
            .receive(on: DispatchQueue.main)
            .sink {
                [weak self] in
                
                if case let .failure(error) = $0 {
                    print("Error: loadCoinMarkets - \(error.localizedDescription)")
                    self?.error = error
                }
                self?.isLoadingPage = false
                self?.isInitialLoading = false
            } receiveValue: {
                [weak self] in
                
                self?.coinMarkets += $0
                self?.isLoadingPage = false
                self?.isInitialLoading = false
            }
            .store(in: &cancellable)
    }
}
