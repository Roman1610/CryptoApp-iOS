import UIKit
import Charts
import Kingfisher
import Networking
import Resources
import Combine

class CoinDetailViewController: UIViewController, UINibInitProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var timePeriodsStackView: UIStackView!
    
    // MARK: - Views
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .infinite)
        indicator.hidesWhenStopped = true
        
        let indicatorSize: CGFloat = 60
        indicator.frame = CGRect(
            x: chartView.bounds.width / 2 - indicatorSize / 2,
            y: chartView.bounds.height / 2 - indicatorSize / 2,
            width: indicatorSize,
            height: indicatorSize
        )
        indicator.style = .large
        
        return indicator
    }()
    
    // MARK: - Properties
    
    weak var coordinator: MainCoordinatorProtocol?
    
    private var coinMarket: CoinMarket?
    private var coinViewModel: CoinDetailViewModel!
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Lifecycle
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTimePeriodButtons()
        configChartView()
    }
    
    // MARK: - IBActions
    
    @IBAction func didBackClicked(_ sender: UIButton) {
        coordinator?.popViewController()
    }
    
    // MARK: - Methods
    
    func setCoin(_ coin: CoinMarket) {
        coinMarket = coin
        configHeader()
    }
    
    func setViewModel(_ viewModel: CoinDetailViewModel) {
        coinViewModel = viewModel
        initViewModel()
    }
    
    private func initViewModel() {
        let chartDataCancellable = coinViewModel.$prices.sink {
            [weak self] prices in
            var chartData = [ChartDataEntry]()
            for (index, price) in prices.enumerated() {
                chartData.append(ChartDataEntry(x: Double(index), y: price, icon: nil))
            }
            
            let chartSet = LineChartDataSet(chartData)
            self?.configChartSet(chartSet)
            
            self?.chartView.data = LineChartData(dataSet: chartSet)
        }
        
        let currentPeriodCancellable = coinViewModel.$isLoading.sink {
            [weak self] isLoading in
            guard let `self` = self else { return }
            
            if isLoading {
                self.chartView.addSubview(self.loadingIndicator)
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.removeFromSuperview()
            }
        }
        
        let periodCancellable = coinViewModel.$period.sink { [weak self] timePeriod in
            self?.updatePeriodButtons(period: timePeriod)
        }
        
        coinViewModel.loadChart()
        
        cancellables.append(chartDataCancellable)
        cancellables.append(currentPeriodCancellable)
        cancellables.append(periodCancellable)
    }
    
    private func initTimePeriodButtons() {
        for timePeriod in TimePeriod.allCases {
            let btn = UIButton()
            btn.tag = timePeriod.rawValue
            
            btn.setTitleColor(UIColor.getAppThemeColor(AppThemeColor.coinDetailPeriodInactiveTextColor), for: .normal)
            btn.setTitle(timePeriod.getName(), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            
            btn.addGestureRecognizer(UITapGestureRecognizer(
                                        target: self,
                                        action: #selector(didTimePeriodClicked(_:))
            ))
            
            btn.layer.cornerRadius = timePeriodsStackView.bounds.height / 2
            btn.translatesAutoresizingMaskIntoConstraints = false
            
            timePeriodsStackView.addArrangedSubview(btn)
        }
    }
    
    private func configChartView() {
        chartView.xAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.pinchZoomEnabled = false
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.dragEnabled = false
    }
    
    private func configChartSet(_ set: LineChartDataSet) {
        set.drawCirclesEnabled = false
        set.lineWidth = 2
        set.drawValuesEnabled = false
    }
    
    private func configHeader() {
        if let imageUrl = coinMarket?.image,
            let url = URL(string: imageUrl) {
            KF.url(url).set(to: coinImage)
        }
        
        let price = (coinMarket?.currentPrice) ?? 0
        let coinSymbol = coinMarket?.symbol.uppercased() ?? ""
        let coinName = coinMarket?.name ?? ""
        
        priceLabel.text = "\(price)"
        coinNameLabel.text = "\(coinName) (\(coinSymbol))"
    }
    
    private func updatePeriodButtons(period: TimePeriod) {
        let allButtons = timePeriodsStackView.subviews
        for btn in allButtons {
            if btn.tag == period.rawValue {
                btn.layer.backgroundColor = UIColor.getAppThemeColor(AppThemeColor.coinDetailPeriodBgColor).cgColor
                (btn as? UIButton)?.setTitleColor(UIColor.getAppThemeColor(AppThemeColor.coinDetailPeriodActiveTextColor), for: .normal)
            } else {
                btn.layer.backgroundColor = UIColor.clear.cgColor
                (btn as? UIButton)?.setTitleColor(UIColor.getAppThemeColor(AppThemeColor.coinDetailPeriodInactiveTextColor), for: .normal)
            }
        }
    }
    
    @objc private func didTimePeriodClicked(_ sender: UITapGestureRecognizer) {
        coinViewModel.period = TimePeriod(rawValue: sender.view?.tag ?? 0) ?? .last1h
    }
}
