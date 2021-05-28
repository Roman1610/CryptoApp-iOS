import Foundation


class SearchViewModel: ObservableObject {
    @Published private(set) var coinMarkets = [CoinMarket]()
    
    @Published private(set) var isLoadingPage = false
    @Published private(set) var isLoadingSearchResults = false
    
    private var currentCurrency = "usd"
    
    private var currentLoadedPages = 0
    private let repository: MainRepositoryProtocol
    
    required init(fetcher: DataFetcherProtocol) {
        self.repository = MainRepository(fetcher: fetcher)
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
        guard !isLoadingPage else {
            return
        }

        isLoadingPage = true
        
        repository.fetchCoinMarkets(page: currentLoadedPages + 1, currency: currentCurrency) { [weak self] coinMarketsData in
            DispatchQueue.main.async {
                self?.coinMarkets += coinMarketsData
            }
            self?.currentLoadedPages += 1
            self?.isLoadingPage = false
        }
    }
}
