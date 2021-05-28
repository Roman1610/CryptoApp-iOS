import UIKit


class SearchViewController: UIViewController, UINibInitProtocol {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var viewModel: SearchViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        initViewModel()
    }

    // MARK: - Methods
    
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            CoinViewCell.nib,
            forCellReuseIdentifier: CoinViewCell.identifier
        )
    }
    
    private func initViewModel() {
        viewModel = SearchViewModel(fetcher: DataFetcher())
    }
}

// MARK: - DataSource & Delegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CoinViewCell.identifier,
            for: indexPath
        ) as! CoinViewCell
        
        
        
        return cell
    }
    
    
}
