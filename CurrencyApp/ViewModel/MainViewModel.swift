import Foundation
import Combine
import Networking

class MainViewModel: ObservableObject {
    
    @Published private(set) var coins = [Coin]()
    @Published private(set) var coinMarkets = [CoinMarket]()
    
    @Published private(set) var isInitialLoading = false
    @Published private(set) var isLoadingPage = false
    
    private var currentCurrency: String
    
    private var currentLoadedPages = 0
    private let repository: MainRepositoryProtocol
    private var cancellables = [AnyCancellable]()
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    required init(fetcher: DataFetcherProtocol) {
        self.repository = MainRepository(fetcher: fetcher)
        currentCurrency = UserDefaults.currency
        UserDefaults.$currency.sink {
            [weak self] newValue in
            
            self?.currentCurrency = newValue
            self?.refreshCoinMarkets()
        }.store(in: &cancellables)
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
        
        repository.fetchCoinMarkets(page: currentLoadedPages + 1,
                                    currency: currentCurrency) {
            [weak self] coinMarketsData in
            
            DispatchQueue.main.async {
                self?.coinMarkets += coinMarketsData
            }
            self?.currentLoadedPages += 1
            self?.isLoadingPage = false
            self?.isInitialLoading = false
        }
    }
}
