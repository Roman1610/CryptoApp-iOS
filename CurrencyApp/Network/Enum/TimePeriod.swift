import Foundation


enum TimePeriod: Int, CaseIterable {
    case last1h = 3600000
    case last24h = 86400000
    case lastWeek = 604800000
    case lastMonth = 2592000000
    case lastHalfYeah = 15552000000
    case lastYear = 31104000000
    
    static func getNames() -> [String] {
        var names = [String]()
        
        for period in TimePeriod.allCases {
            switch period {
            case .last1h:
                names.append("1H")
            case .last24h:
                names.append("24H")
            case .lastWeek:
                names.append("7D")
            case .lastMonth:
                names.append("1M")
            case .lastHalfYeah:
                names.append("6M")
            case .lastYear:
                names.append("1Y")
            }
        }
        
        return names
    }
    
    func getName() -> String {
        switch self {
        case .last1h:
            return "1H"
        case .last24h:
            return "24H"
        case .lastWeek:
            return "7D"
        case .lastMonth:
            return "1M"
        case .lastHalfYeah:
            return "6M"
        case .lastYear:
            return "1Y"
        }
    }
}
