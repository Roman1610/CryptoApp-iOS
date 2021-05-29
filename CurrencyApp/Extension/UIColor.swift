import Foundation
import UIKit


extension UIColor {
    static func getAppThemeColor(_ name: AppThemeColor) -> UIColor {
        return UIColor(named: name.rawValue)!
    }
}
