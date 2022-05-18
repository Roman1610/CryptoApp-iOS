import Networking
import Combine
import Foundation

class SearchViewModel: ObservableObject {
    
    // Output
    @Published private(set) var coinMarkets = [CoinMarket]()
    
    @Published private(set) var isLoadingPage = false
    @Published private(set) var isLoadingSearchResults = false
    
    @Published private var currentLoadedPages = 0
    
    private var currentCurrency = "usd"
    private let repository: MainRepositoryProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    deinit {
        cancellable.forEach { $0.cancel() }
    }
    
    required init(fetcher: DataFetcherProtocol) {
        self.repository = MainRepository(fetcher: fetcher)
        
//        iOS 14
//        $currentLoadedPages
//            .flatMap {
//                (page) -> AnyPublisher<[CoinMarket], CryptoError> in
//
//                repository.fetchCoinMarkets(page: currentLoadedPages + 1, currency: currentCurrency)
//            }
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
        guard !isLoadingPage else {
            return
        }
        
        isLoadingPage = true
        
        repository.fetchCoinMarkets(page: currentLoadedPages + 1, currency: currentCurrency)
            .receive(on: DispatchQueue.main)
            .sink {
                [weak self] in
                
                if case let .failure(error) = $0 {
                    print("Error: loadCoinMarkets - \(error.localizedDescription)")
                }
                self?.isLoadingPage = false
            } receiveValue: {
                [weak self] in
                
                self?.coinMarkets = $0
                self?.isLoadingPage = false
            }
            .store(in: &cancellable)
    }
}
