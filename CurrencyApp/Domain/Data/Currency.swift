import Foundation


struct Currency: Hashable, Identifiable {
    let id: String
    
    init(currencyName: String) {
        id = currencyName
    }
}
