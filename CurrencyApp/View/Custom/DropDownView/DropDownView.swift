import UIKit


protocol UIDropDownTableViewCell: UITableViewCell {
    associatedtype Model
    func bind(_: Model)
}

protocol UIDropDownCellDelegate {
    func didSelect(at index: Int)
}


class DropDownView<CellType: UIDropDownTableViewCell>:
    UIView, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var items: [CellType.Model] = []

    var delegate: UIDropDownCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func setItems(_ list: [CellType.Model]) {
        items = list
        tableView.reloadData()
    }
    
    private func customInit() {
        Bundle.main.loadNibNamed("DropDownView", owner: self, options: nil)
        contentView.fillSuperview(self)
        
        contentView.addShadow(offset: .zero)
        contentView.layer.cornerRadius = 15
        tableView.layer.cornerRadius = 15
        
        configTableView()
    }
    
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CellType.nib,
            forCellReuseIdentifier: CellType.identifier
        )
    }
    
    
    // MARK: - Table DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CellType.identifier,
            for: indexPath
        ) as! CellType
        
        let item = items[indexPath.row]
        cell.bind(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.didSelect(at: indexPath.row)
    }
}
