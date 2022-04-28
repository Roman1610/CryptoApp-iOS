import UIKit

class CurrencyViewCell: UITableViewCell, UIDropDownTableViewCell {
    
    typealias Model = Currency
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(_ currency: Currency) {
        label.text = currency.id.uppercased()
    }
}
