import Foundation
import UIKit


protocol MainCoordinatorProtocol: AnyObject {
    func navigateToCoinDetail(_ coin: CoinMarket)
    func navigateToSearch()
    func navigateToSettings()
    func popViewController()
}


class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let dataFetcher = DataFetcher()

    init(_ nav: UINavigationController) {
        navigationController = nav
        navigationController.navigationBar.isHidden = true
        navigationController.interactivePopGestureRecognizer?.delegate = nil
    }

    func start() {
        let vc = MainViewController.instantiate()
        vc.coordinator = self
        vc.setViewModel(viewModel: MainViewModel(fetcher: dataFetcher))
        navigationController.pushViewController(vc, animated: true)
    }
    
}


extension MainCoordinator: MainCoordinatorProtocol {
   
    func navigateToCoinDetail(_ coin: CoinMarket) {
        let coinViewModel = CoinDetailViewModel(
            fetcher: dataFetcher,
            coinId: coin.id,
            coinName: coin.name
        )
        let vc = CoinDetailViewController.instantiate()
        vc.coordinator = self
        vc.setViewModel(coinViewModel)
        vc.setCoin(coin)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSearch() {
        let vc = SearchViewController.instantiate()
        vc.coordinator = self
        let viewModel = SearchViewModel(fetcher: dataFetcher)
        vc.setViewModel(viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSettings() {
        let vc = SettingsViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
}
