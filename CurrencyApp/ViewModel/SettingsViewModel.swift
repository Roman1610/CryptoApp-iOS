import Foundation
import Networking
import Combine

class SettingsViewModel: ObservableObject {
    
    @Published private(set) var currencies = [Currency]()
    @Published private(set) var isLoading = false
    
    private let repository: SettingsRepository
    
    private var cancellable = Set<AnyCancellable>()
    
    deinit {
        cancellable.forEach { $0.cancel() }
    }
    
    init(fetcher: DataFetcher) {
        repository = SettingsRepository(fetcher: fetcher)
    }
    
    private func loadSupportedCurrencies() {
        isLoading = true
        repository.fetchSupportedCurrencies()
            .receive(on: DispatchQueue.main)
            .sink {
                [weak self] in
                
                if case let .failure(error) = $0 {
                    print("Error: loadSupportedCurrencies - \(error.localizedDescription)")
                }
                self?.isLoading = false
            } receiveValue: {
                [weak self] in
                
                self?.currencies = $0
                self?.isLoading = false
            }
            .store(in: &cancellable)
    }
}
