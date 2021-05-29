import Foundation


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
    
    deinit {
        debugPrint("CoinDetailViewModel deinit")
    }
    
    init(fetcher: DataFetcherProtocol, coinId: String, coinName: String) {
        debugPrint("CoinDetailViewModel init")
        self.repository = CoinDetailRepository(fetcher: fetcher)
        self.coinId = coinId
        self.coinName = coinName
        self.currency = UserDefaults.currency
    }
    
    func loadChart() {
        isLoading = true
        let currentTimestamp = Int(Date().timeIntervalSince1970) * 1000
        let beforeTimestamp = currentTimestamp - period.rawValue
        
        repository.fetchCoinChartRange(id: coinId, currency: currency, from: beforeTimestamp / 1000, to: currentTimestamp / 1000) { data in
            DispatchQueue.global(qos: .background).async {
                var min = Double.greatestFiniteMagnitude
                for item in data {
                    if item.price < min {
                        min = item.price
                    }
                }
                
                var prices = [Double]()
                for item in data {
                    prices.append(item.price)
                }
                
                DispatchQueue.main.async {
                    self.prices = prices
                    debugPrint("CoinDetailViewModel: loadData \(data.count)")
                    self.isLoading = false
                }
            }
        }
    }
    
    
}
