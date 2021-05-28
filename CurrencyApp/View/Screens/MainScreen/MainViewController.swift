import UIKit
import Combine


class MainViewController: UIViewController {
    
    // MARK: - Constants
    
    private let tableCellHeight: CGFloat = 60
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var changeCurrencyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Views
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .infinite)
        indicator.hidesWhenStopped = true
        indicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 60)
        indicator.style = .large
        
        return indicator
    }()
    
    private lazy var dropDownView: DropDownView<CurrencyViewCell> = {
        let width = view.bounds.size.width / 3
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
    
    @IBAction func didSearchClicked(_ sender: UIButton) {
        navigationController?.pushViewController(SearchViewController.instantiate(), animated: true)
    }
    
    // MARK: - Private Methods
    
    private func configTableView() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCoins(_:)), for: .valueChanged)
//        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Coins Data...")
        
        tableView.register(
            CoinViewCell.nib,
            forCellReuseIdentifier: CoinViewCell.identifier
        )
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func initViewModel() {
        mainViewModel = MainViewModel(fetcher: DataFetcher())
        
        let loadingPageCancellable = mainViewModel.$isLoadingPage.sink {
            [weak self] isLoading in
            
            if isLoading {
                self?.tableView?.tableFooterView = self?.loadingIndicator
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
                self?.tableView?.tableFooterView = nil
            }
        }
        
        let loadingInitCancellable = mainViewModel.$isInitialLoading.sink {
            [weak self] isLoading in
            
            if isLoading {
                self?.refreshControl.beginRefreshing()
            } else {
                self?.refreshControl.endRefreshing()
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
        
        viewModelCancellables.append(loadingPageCancellable)
        viewModelCancellables.append(loadingInitCancellable)
        viewModelCancellables.append(coinsMarketCancellable)
        viewModelCancellables.append(currenciesCancellable)
        
        refreshControl.beginRefreshing()
        mainViewModel.loadData()
    }
    
    @objc private func refreshCoins(_ sender: Any) {
        mainViewModel.loadData()
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.bind(coin: coin)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let coin = coinsMarket[indexPath.row]
        
        navigationController?.pushViewController(
            CoinDetailVC.getController(coinMarket: coin, currency: mainViewModel.currentCurrency),
            animated: true
        )
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= tableView.numberOfRows(inSection: 0) - 2 {
            mainViewModel.loadMore()
        }
    }
}

// MARK: - DropDownDelegate
extension MainViewController: UIDropDownCellDelegate {
    func didSelect(at index: Int) {
        mainViewModel.currentCurrency = mainViewModel.currencies[index].id
        isDropDownOpen = false
    }
}
