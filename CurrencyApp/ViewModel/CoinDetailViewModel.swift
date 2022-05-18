import Foundation
import Networking
import Combine

class CoinDetailViewModel: ObservableObject {
    
    @Published var period = TimePeriod.last24h {
        didSet {
            loadChart()
        }
    }
    
    @Published private(set) var prices = [Double]()
    @Published private(set) var isLoading = false
    
    private(set) var coinId: String
    private(set) var coinName: String
    private(set) var currency: String
    
    private let repository: CoinDetailRepositoryProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    deinit {
        cancellable.forEach { $0.cancel() }
    }
    
    init(fetcher: DataFetcherProtocol, coinId: String, coinName: String) {
        self.repository = CoinDetailRepository(fetcher: fetcher)
        self.coinId = coinId
        self.coinName = coinName
        self.currency = UserDefaults.currency
    }
    
    func loadChart() {
        isLoading = true
        let currentTimestamp = Int(Date().timeIntervalSince1970) * 1000
        let beforeTimestamp = currentTimestamp - period.rawValue
        
        repository.fetchCoinChartRange(id: coinId,
                                       currency: currency,
                                       from: beforeTimestamp / 1000,
                                       to: currentTimestamp / 1000)
            .receive(on: DispatchQueue.main)
            .sink {
                [weak self] in
                
                if case let .failure(error) = $0 {
                    print("Error: fetchCoinChartRange -  \(error.localizedDescription)")
                }
                self?.isLoading = false
            } receiveValue: {
                [weak self] receivedValue in
                
                var min = Double.greatestFiniteMagnitude
                for item in receivedValue {
                    if item.price < min {
                        min = item.price
                    }
                }
                
                var prices = [Double]()
                for item in receivedValue {
                    prices.append(item.price)
                }
                
                self?.prices = prices
                self?.isLoading = false
            }
            .store(in: &cancellable)
    }
}
