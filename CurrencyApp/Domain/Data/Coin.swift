import Foundation
import Networking

struct Coin: Hashable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    
    init(id: String, symbol: String, name: String) {
        self.id = id
        self.symbol = symbol
        self.name = name
    }
    
    init(coin: ResponseCoin) {
        id = coin.id
        symbol = coin.symbol
        name = coin.name
    }
}
