//
//  ROute.swift
//  Networking
//
//  Created by Роман Уваров on 18.05.2022.
//

import Foundation

enum Route {
    
    private static let baseUrl = URL(string: "https://api.coingecko.com/api/v3")
    
    /// List of supported_vs_currencies
    case getSupportedCurrencies
    /// List all supported coins id, name and symbol (no pagination required
    case getCoins(includePlatform: Bool? = nil)
    /// List all supported coins price, market cap, volume, and market related data
    case getCoinMarkets(currency: String, page: Int, order: GeckoSortResultEnum? = nil, perPage: Int = 50)
    /// Get historical market data include price, market cap, and 24h volume (granularity auto)
    case getCoinMarketChart(id: String, currency: String, days: Int)
    /// Get historical market data include price, market cap, and 24h volume within a range of timestamp (granularity auto)
    case getCoinMarketChartRange(id: String, currency: String, from: Int, to: Int)
    
    var requestUrl: URL? {
        guard let url = url else {
            return nil
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = params?.map { URLQueryItem(name: $0, value: $1) }
        
        return components?.url
    }
    
    private var url: URL? {
        switch self {
        case .getSupportedCurrencies:
            return Route.baseUrl?.appendingPathComponent("simple/supported_vs_currencies")
        case .getCoins:
            return Route.baseUrl?.appendingPathComponent("coins/list")
        case .getCoinMarkets:
            return Route.baseUrl?.appendingPathComponent("coins/markets")
        case let .getCoinMarketChart(id, _, _):
            return Route.baseUrl?.appendingPathComponent("coins/\(id)/market_chart")
        case let .getCoinMarketChartRange(id, _, _, _):
            return Route.baseUrl?.appendingPathComponent("coins/\(id)/market_chart/range")
        }
    }
    
    private var params: [String: String]? {
        switch self {
        case .getSupportedCurrencies:
            return nil
        case let .getCoins(includePlatform):
            guard let includePlatform = includePlatform else {
                return nil
            }
            return [
                "include_platform" : String(includePlatform)
            ]
        case let .getCoinMarkets(currency, page, order, perPage):
            var params: [String: String] = ["vs_currency": currency,
                                            "per_page": String(perPage),
                                            "page": String(page)]
            if let order = order {
                params["order"] = order.rawValue
            }
            return params
        case let .getCoinMarketChart(_, currency, days):
            return [
                "vs_currency": currency,
                "days": String(days)
            ]
        case let .getCoinMarketChartRange(_, currency, from, to):
            return [
                "vs_currency": currency,
                "from": String(from),
                "to": String(to)
            ]
        }
    }
}
