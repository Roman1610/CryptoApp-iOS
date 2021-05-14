import Foundation
import Alamofire


protocol DataFetcherProtocol: AnyObject {
    func fetchSupportedCurrencies(completion: @escaping ([String]) -> ())
    func fetchAllCoins(completion: @escaping ([ResponseCoin]) -> ())
    func fetchCoinMarkets(page: Int, currency: String, order: GeckoSortResultEnum?, perPage: Int, completion: @escaping ([ResponseCoinMarket]) -> ())
    func fetchCoinMarketChart(id: String, currency: String, days: Int, completion: @escaping (ResponseCoinMarketChartData) -> ())
    func fetchCoinMarketChartRange(id: String, currency: String, from: Int64, to: Int64, completion: @escaping (ResponseCoinMarketChartData) -> ())
}


class DataFetcher: DataFetcherProtocol {
    
    // MARK: - Variables
    
    private enum Route {
        private static let baseUrl = "https://api.coingecko.com/api/v3"
        
        /// List of supported_vs_currencies
        case getSupportedCurrencies
        /// List all supported coins id, name and symbol (no pagination required
        case getCoins(includePlatform: Bool? = nil)
        /// List all supported coins price, market cap, volume, and market related data
        case getCoinMarkets(currency: String, page: Int, order: GeckoSortResultEnum? = nil, perPage: Int = 50)
        /// Get historical market data include price, market cap, and 24h volume (granularity auto)
        case getCoinMarketChart(id: String, currency: String, days: Int)
        /// Get historical market data include price, market cap, and 24h volume within a range of timestamp (granularity auto)
        case getCoinMarketChartRange(id: String, currency: String, from: Int64, to: Int64)
        
        
        var path: String {
            switch self {
            case .getSupportedCurrencies:
                return "\(Route.baseUrl)/simple/supported_vs_currencies"
            case .getCoins(let includePlatform):
                return "\(Route.baseUrl)/coins/list" + (includePlatform != nil ? "?include_platform=\(includePlatform!)" : "")
            case .getCoinMarkets(let currency, let page, let order, let perPage):
                return "\(Route.baseUrl)/coins/markets?vs_currency=\(currency)&per_page=\(perPage)&page=\(page)" + (order != nil ? "&order=\(order!.rawValue)" : "")
            case .getCoinMarketChart(let id, let currency, let days):
                return "\(Route.baseUrl)/coins/\(id)/market_chart?vs_currency=\(currency)&days=\(days)"
            case .getCoinMarketChartRange(let id, let currency, let from, let to):
                return "\(Route.baseUrl)/coins/\(id)/market_chart/range?vs_currency=\(currency)&from=\(from)&to=\(to)"
            }
        }
    }
    
    private var chartDataRequest: DataRequest?
    
    // MARK: - Methods
    
    func fetchSupportedCurrencies(completion: @escaping ([String]) -> ()) {
        _ = request(.getSupportedCurrencies) { responseString in
            if let currenciesData = try? JSONDecoder().decode([String].self, from: responseString.data(using: .utf8)!) {
                completion(currenciesData)
            }
        }
    }
    
    func fetchAllCoins(completion: @escaping ([ResponseCoin]) -> ()) {
        _ = request(.getCoins()) { responseString in
            if let coinsData = try? JSONDecoder().decode([ResponseCoin].self, from: responseString.data(using: .utf8)!) {
                completion(coinsData)
            }
        }
    }
    
    func fetchCoinMarkets(
        page: Int,
        currency: String,
        order: GeckoSortResultEnum? = nil,
        perPage: Int = 50,
        completion: @escaping ([ResponseCoinMarket]) -> ()
    ) {
        _ = request(.getCoinMarkets(currency: currency, page: page, order: order, perPage: perPage)) { responseString in
            let coinsData = try! JSONDecoder().decode([ResponseCoinMarket].self, from: responseString.data(using: .utf8)!)
            completion(coinsData)
        }
    }
    
    func fetchCoinMarketChart(id: String, currency: String, days: Int, completion: @escaping (ResponseCoinMarketChartData) -> ()) {
        chartDataRequest?.cancel()
        chartDataRequest = request(.getCoinMarketChart(id: id, currency: currency, days: days)) { responseString in
            completion(ResponseCoinMarketChartData(from: responseString, type: "prices"))
        }
    }
    
    func fetchCoinMarketChartRange(id: String, currency: String, from: Int64, to: Int64, completion: @escaping (ResponseCoinMarketChartData) -> ()) {
        chartDataRequest?.cancel()
        chartDataRequest = request(.getCoinMarketChartRange(id: id, currency: currency, from: from, to: to)) { responseString in
            completion(ResponseCoinMarketChartData(from: responseString, type: "prices"))
        }
    }
    
    private func request(_ route: Route, success: @escaping (String) -> (), failure: ((String) -> ())? = nil) -> DataRequest {
        debugPrint("DataFetcher:", route.path)
        
        return AF.request(route.path).responseString { response in
            switch response.result {
            case .success(let value):
                debugPrint("DataFetcher: success -", value)
                success(value)
                break
            case .failure(let error):
                debugPrint("DataFetcher: failure -", error.localizedDescription)
                failure?(error.localizedDescription)
                break
            }
        }
    }
    
}
