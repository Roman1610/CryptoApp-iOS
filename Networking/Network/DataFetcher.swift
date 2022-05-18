import Foundation
import Combine

public protocol DataFetcherProtocol: AnyObject {
    
    func fetchSupportedCurrencies() -> AnyPublisher<[String], CryptoError>
    func fetchAllCoins() -> AnyPublisher<[ResponseCoin], CryptoError>
    func fetchCoinMarkets(page: Int,
                          currency: String,
                          order: GeckoSortResultEnum?,
                          perPage: Int) -> AnyPublisher<[ResponseCoinMarket], CryptoError>
    func fetchCoinMarketChart(id: String,
                              currency: String,
                              days: Int) -> AnyPublisher<ResponseCoinMarketChartData, CryptoError>
    func fetchCoinMarketChartRange(id: String,
                                   currency: String,
                                   from: Int,
                                   to: Int) -> AnyPublisher<ResponseCoinMarketChartData, CryptoError>
}

public enum CryptoError: Error {
    case wrongUrl(String?)
    case decoding
    case response(Int, String)
    case other(Error)
    
    public var description: String {
        switch self {
        case let .wrongUrl(urlString):
            return "Неверный URL\n\(String(describing: urlString))"
        case .decoding:
            return "Ошиба декодирования ответа"
        case let .response(status, desc):
            return "Ошибка запроса\nСтатус - \(status)\n\(desc)"
        case let .other(error):
            return "Что-то пошло не так.\n\(error.localizedDescription)"
        }
    }
}

public class DataFetcher: DataFetcherProtocol {
    
    // MARK: - Variables
    
    
    
    private var cancellable = Set<AnyCancellable>()
    
    public init() {}
    
    // MARK: - Methods
    
    public func fetchSupportedCurrencies() -> AnyPublisher<[String], CryptoError> {
        request(.getSupportedCurrencies)
    }
    
    public func fetchAllCoins() -> AnyPublisher<[ResponseCoin], CryptoError> {
        request(.getCoins())
    }
    
    public func fetchCoinMarkets(page: Int,
                                 currency: String,
                                 order: GeckoSortResultEnum? = nil,
                                 perPage: Int = 50) -> AnyPublisher<[ResponseCoinMarket], CryptoError> {
        request(.getCoinMarkets(currency: currency, page: page, order: order, perPage: perPage))
    }
    
    public func fetchCoinMarketChart(id: String, currency: String, days: Int) -> AnyPublisher<ResponseCoinMarketChartData, CryptoError> {
        request(.getCoinMarketChart(id: id, currency: currency, days: days))
            .map {
                ResponseCoinMarketChartData(from: $0, type: "prices")
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchCoinMarketChartRange(id: String,
                                          currency: String,
                                          from: Int,
                                          to: Int) -> AnyPublisher<ResponseCoinMarketChartData, CryptoError> {
        request(.getCoinMarketChartRange(id: id, currency: currency, from: from, to: to))
            .map {
                ResponseCoinMarketChartData(from: $0, type: "prices")
            }
            .eraseToAnyPublisher()
    }
    
    private func request<T: Decodable>(_ route: Route) -> AnyPublisher<T, CryptoError> {
        guard let url = route.requestUrl else {
            return Fail(error: .wrongUrl(route.requestUrl?.absoluteString)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap {
                data, response in
                
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    throw CryptoError.response((response as? HTTPURLResponse)?.statusCode ?? 500,
                                               String(data: data, encoding: .utf8) ?? "")
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError {
                error in
                
                switch error {
                case _ as DecodingError:
                    return CryptoError.decoding
                default:
                    return CryptoError.other(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
