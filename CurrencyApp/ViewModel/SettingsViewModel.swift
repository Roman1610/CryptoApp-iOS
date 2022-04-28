import Foundation
import Networking

class SettingsViewModel: ObservableObject {
    
    @Published private(set) var currencies = [Currency]()
    @Published private(set) var isLoading = false
    
    private let repository: SettingsRepository
    
    init(fetcher: DataFetcher) {
        repository = SettingsRepository(fetcher: fetcher)
    }
    
    private func loadSupportedCurrencies() {
        isLoading = true
        repository.fetchSupportedCurrencies {
            [weak self] currencies in
            
            DispatchQueue.main.async {
                self?.currencies = currencies
            }
            self?.isLoading = false
        }
    }
}
