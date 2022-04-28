import UIKit
import Kingfisher

class CoinViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinSymbolLabel: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Methods
    
    func bind(coin: CoinMarket) {
        coinNameLabel.text = coin.name
        coinSymbolLabel.text = coin.symbol.uppercased()
        priceLabel.text = "\(coin.currentPrice)"
        
        let percent = ((coin.priceChangePercentage24h ?? 0) * 10).rounded() / 10
        percentLabel.text = "\(percent)%"
        percentLabel.textColor = percent < 0 ? UIColor.systemRed : UIColor.systemGreen
        
        if let imageUrl = URL(string: coin.image) {
            KF.url(imageUrl).set(to: coinImage)
        }
    }
}
