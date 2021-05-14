import Foundation


class MainViewModel: ObservableObject {
    @Published private(set) var currencies = [Currency]()
    @Published private(set) var coins = [Coin]()
    @Published private(set) var coinMarkets = [CoinMarket]()
    
    @Published private(set) var isLoadingPage = false
    @Published private(set) var isCurrenciesLoading = false
    
    @Published var currentCurrency = "usd" {
        didSet {
            updateData()
        }
    }
    
    private var currentLoadedPages = 1
    private let repository: MainRepositoryProtocol
    
    required init(fetcher: DataFetcherProtocol) {
        self.repository = MainRepository(fetcher: fetcher)
    }
    
    func loadData() {
        loadCoinMarkets()
        loadSupportedCurrencies()
    }
    
    func loadAllCoins() {
        isLoadingPage = true
        repository.fetchAllData { [weak self] coinsData in
            DispatchQueue.main.async {
                self?.coins = coinsData
            }
        }
    }
    
    private func loadCoinMarkets() {
        guard !isLoadingPage else {
            return
        }

        isLoadingPage = true
        
        repository.fetchCoinMarkets(page: currentLoadedPages, currency: currentCurrency) { [weak self] coinMarketsData in
            DispatchQueue.main.async {
                self?.coinMarkets += coinMarketsData
            }
            self?.currentLoadedPages += 1
            self?.isLoadingPage = false
        }
    }
    
    private func loadSupportedCurrencies() {
        isCurrenciesLoading = true
        repository.fetchSupportedCurrencies { [weak self] currencies in
            DispatchQueue.main.async {
                debugPrint("MainViewModel: fetchSupportedCurrencies -", currencies)
                self?.currencies = currencies
            }
            self?.isCurrenciesLoading = false
        }
    }
    
    private func updateData() {
        currentLoadedPages = 0
        coinMarkets.removeAll()
        loadCoinMarkets()
    }
}
