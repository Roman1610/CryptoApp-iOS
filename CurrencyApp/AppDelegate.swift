import UIKit
import Messages
import Firebase

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
}
