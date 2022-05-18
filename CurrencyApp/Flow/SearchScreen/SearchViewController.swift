import UIKit


class SearchViewController: UIViewController, UINibInitProtocol {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    
    weak var coordinator: MainCoordinatorProtocol!
    
    private var searchViewModel: SearchViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configSearchBar()
        configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.searchTextField.becomeFirstResponder()
    }

    // MARK: - Methods
    
    func setViewModel(_ viewModel: SearchViewModel) {
        searchViewModel = viewModel
        initViewModel()
    }
    
    private func configSearchBar() {
        searchBar.delegate = self
    }
    
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            CoinViewCell.nib,
            forCellReuseIdentifier: CoinViewCell.identifier
        )
    }
    
    private func initViewModel() {
        
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

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
}
