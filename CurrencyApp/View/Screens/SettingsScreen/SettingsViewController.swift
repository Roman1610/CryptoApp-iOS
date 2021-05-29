import UIKit


class SettingsViewController: UIViewController, UINibInitProtocol {

    // MARK: - IBOutlets
    
    @IBOutlet weak var currencySettingView: UIView!
    
    // MARK: - Properties
    
    weak var coordinator: MainCoordinatorProtocol?
    
    private var settingsViewModel: SettingsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configSettings()
    }
    
    func setViewModel(_ viewModel: SettingsViewModel) {
        settingsViewModel = viewModel
        initViewModel()
    }
    
    private func initViewModel() {
        
    }
    
    private func configSettings() {
        currencySettingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didChangeCurrencyClicked(_:))))
    }

    
    @objc private func didChangeCurrencyClicked(_ sender: UITapGestureRecognizer) {
        // Открыть sheet с валютами
    }
}
