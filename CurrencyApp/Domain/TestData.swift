import Foundation


class TestData {
    
    static var shared = TestData()
    
    
    func getCoinMarket() -> CoinMarket {
        return CoinMarket(
            id: "test_id",
            symbol: "TEST",
            name: "Test Name",
            image: "https://www.google.com/url?sa=i&url=http%3A%2F%2Fwww.60x60.com%2F2014_Wave_Farm_Mix.htm&psig=AOvVaw1gD0krtSPoTEOHBko7wV1v&ust=1616438743087000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCLDtn66Iwu8CFQAAAAAdAAAAABAD",
            currentPrice: 123.45
        )
    }
    
}
