import UIKit
import Combine


class MainViewController: UIViewController {
    
    // MARK: - Constants
    
    private let tableCellHeight: CGFloat = 50
    private let tableHeaderViewHeight: CGFloat = 50
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var changeCurrencyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Views
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .infinite)
        indicator.hidesWhenStopped = true
        indicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 60)
        indicator.style = .large
        
        return indicator
    }()
    
    private lazy var dropDownView: DropDownView<CurrencyViewCell> = {
        let width = view.bounds.size.width / 2
        let height = 2 * view.bounds.size.height / 3
        
        var x = changeCurrencyButton.frame.minX - width - 5
        var y = changeCurrencyButton.frame.minY + 15
        
        let view = DropDownView<CurrencyViewCell>(
            frame: CGRect(
                x: x,
                y: y,
                width: width,
                height: height
            )
        )
        
        view.delegate = self
        return view
    }()
    
    // MARK: - Properties
    private var mainViewModel: MainViewModel!
    private var viewModelCancellables: [AnyCancellable] = []
    private var coinsMarket: [CoinMarket] = []
    private var isDropDownOpen = false {
        didSet {
            if isDropDownOpen {
                view.addSubview(dropDownView)
            } else {
                dropDownView.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    deinit {
        viewModelCancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        initViewModel()
    }
    
    // MARK: - IBActions
    
    @IBAction func didCurrencyClicked(_ sender: UIButton) {
        isDropDownOpen = !isDropDownOpen
    }
    
    
    // MARK: - Private Methods
    
    private func configTableView() {
        tableView.register(
            CoinViewCell.nib,
            forCellReuseIdentifier: CoinViewCell.identifier
        )
        tableView.register(
            CoinsHeaderView.nib,
            forHeaderFooterViewReuseIdentifier: CoinsHeaderView.identifier
        )
        tableView.tableFooterView = loadingIndicator
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func initViewModel() {
        mainViewModel = MainViewModel(fetcher: DataFetcher())
        
        let loadingCancellable = mainViewModel.$isLoadingPage.sink {
            [weak self] isLoading in
            
            if isLoading {
                self?.tableView?.tableFooterView = self?.loadingIndicator
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
                self?.tableView?.tableFooterView = nil
            }
        }
        
        let coinsMarketCancellable = mainViewModel.$coinMarkets.sink {
            [weak self] coins in
            self?.coinsMarket = coins
            self?.tableView?.reloadData()
        }
        
        let currenciesCancellable = mainViewModel.$currencies.sink {
            [weak self] currencies in
            self?.dropDownView.setItems(currencies)
        }
        
        viewModelCancellables.append(loadingCancellable)
        viewModelCancellables.append(coinsMarketCancellable)
        viewModelCancellables.append(currenciesCancellable)
        
        mainViewModel.loadData()
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CoinsHeaderView.identifier
        ) as! CoinsHeaderView
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableCellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinsMarket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CoinViewCell.identifier,
            for: indexPath
        ) as! CoinViewCell
        
        let coin = coinsMarket[indexPath.row]
        cell.bind(number: indexPath.row + 1, coin: coin)
        
        return cell
    }
}

// MARK: - DropDownDelegate
extension MainViewController: UIDropDownCellDelegate {
    func didSelect(at index: Int) {
        mainViewModel.currentCurrency = mainViewModel.currencies[index].id
        isDropDownOpen = false
    }
}
