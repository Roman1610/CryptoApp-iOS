import UIKit
import Kingfisher


class CoinViewCell: UITableViewCell {
    
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var coinSymbolLabel: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func bind(number: Int, coin: CoinMarket) {
        numberLabel.text = "\(number)"
        coinSymbolLabel.text = coin.symbol.uppercased()
        priceLabel.text = "\(coin.currentPrice)"
        
        let percent = ((coin.priceChangePercentage24h ?? 0) * 10).rounded() / 10
        percentLabel.text = "\(percent)%"
        
        capitalLabel.text = "\(coin.marketCap.rounded())"
        
        if let imageUrl = URL(string: coin.image) {
            KF.url(imageUrl).set(to: coinImage)
        }
    }
    
}
