import UIKit
import Combine


class MainViewController: UIViewController, UINibInitProtocol {
    
    // MARK: - Constants
    
    private let tableCellHeight: CGFloat = 60
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Views
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = CustomRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCoins(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        
        return refreshControl
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .infinite)
        indicator.hidesWhenStopped = true
        indicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 60)
        indicator.style = .large
        indicator.color = .white
        
        return indicator
    }()
    
    // MARK: - Properties
    
    weak var coordinator: MainCoordinatorProtocol?
    
    private var mainViewModel: MainViewModel!
    private var viewModelCancellables: [AnyCancellable] = []
    private var coinsMarket: [CoinMarket] = []
    
    // MARK: - Lifecycle
    
    deinit {
        viewModelCancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
    }
    
    // MARK: - IBActions
    
    @IBAction func didSearchClicked(_ sender: UIButton) {
        coordinator?.navigateToSearch()
    }
    
    @IBAction func didSettingsClicked(_ sender: UIButton) {
        coordinator?.navigateToSettings()
    }
    
    // MARK: - Methods
    
    func setViewModel(viewModel: MainViewModel) {
        mainViewModel = viewModel
        initViewModel()
    }
    
    // MARK: - Private Methods
    
    private func configTableView() {
        tableView.refreshControl = refreshControl
        
        tableView.register(
            CoinViewCell.nib,
            forCellReuseIdentifier: CoinViewCell.identifier
        )
    }
    
    private func initViewModel() {
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
        
        viewModelCancellables.append(loadingPageCancellable)
        viewModelCancellables.append(loadingInitCancellable)
        viewModelCancellables.append(coinsMarketCancellable)
        
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
        
        coordinator?.navigateToCoinDetail(coin)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= tableView.numberOfRows(inSection: 0) - 2 {
            mainViewModel.loadMore()
        }
    }
}
