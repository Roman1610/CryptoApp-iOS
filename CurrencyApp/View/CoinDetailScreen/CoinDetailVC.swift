import Foundation
import UIKit
import Charts
import Combine
import Kingfisher


class CoinDetailVC: UIViewController {
    
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
    
    private var coinMarket: CoinMarket?
    private var currency: String = ""
    
    private var coinViewModel: CoinDetailViewModel!
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Init
    
    static func getController(
        coinMarket: CoinMarket,
        currency: String
    ) -> UIViewController {
        let storyboard = UIStoryboard(name: "CoinDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CoinDetailVC") as! CoinDetailVC
        vc.coinMarket = coinMarket
        vc.currency = currency
        return vc
    }
    
    // MARK: - Lifecycle
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTimePeriodButtons()
        configChartView()
        initViewModel()
        configHeader()
    }
    
    // MARK: - IBActions
    
    @IBAction func didBackClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func initViewModel() {
        coinViewModel = CoinDetailViewModel(
            fetcher: DataFetcher(),
            coinId: coinMarket?.id ?? "",
            coinName: coinMarket?.name ?? "",
            currency: currency
        )
        
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
            
            btn.setTitleColor(UIColor.black, for: .normal)
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
                btn.layer.backgroundColor = UIColor.systemGreen.cgColor
                (btn as? UIButton)?.setTitleColor(UIColor.white, for: .normal)
            } else {
                btn.layer.backgroundColor = UIColor.clear.cgColor
                (btn as? UIButton)?.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }
    
    @objc private func didTimePeriodClicked(_ sender: UITapGestureRecognizer) {
        coinViewModel.period = TimePeriod(rawValue: sender.view?.tag ?? 0) ?? .last1h
    }
}
