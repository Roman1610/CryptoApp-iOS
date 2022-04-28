import Foundation
import Networking

struct CoinRoi: Hashable {
    let times: Double
    let currency: String
    let percentage: Double
    
    init(coinRoi: ResponseCoinRoi) throws {
        times = coinRoi.times
        currency = coinRoi.currency
        percentage = coinRoi.percentage
    }
}
