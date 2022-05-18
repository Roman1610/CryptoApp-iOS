import UIKit
import Messages
import Firebase
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private enum Constants {
        enum Firebase {
            static let plist = "GoogleService-Info"
            static let type = "plist"
        }
    }
    
    var window: UIWindow?
    private let rootViewController = UINavigationController()
    private var coordinator: MainCoordinator!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configFirebase()
        configKF()
        
        window = UIWindow()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        coordinator = MainCoordinator(rootViewController)
        coordinator.start()
        
        return true
    }
    
    private func configFirebase() {
        guard let filePath = Bundle.main.path(forResource: Constants.Firebase.plist,
                                              ofType: Constants.Firebase.type),
              let options = FirebaseOptions(contentsOfFile: filePath) else {
            return
        }
        FirebaseApp.configure(options: options)
    }
    
    private func configKF() {
        ImageCache.default.memoryStorage.config.totalCostLimit = 1024 * 1024 * 10 // 10 MB
        ImageCache.default.diskStorage.config.sizeLimit = 1024 * 1024 * 10 // 10 MB
    }
}
