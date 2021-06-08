import Foundation
import UIKit
import SwiftUI


extension UIColor {
    static func getAppThemeColor(_ name: AppThemeColor) -> UIColor {
        return UIColor(named: name.rawValue)!
    }
}

extension Color {
    static func getAppThemeColor(_ name: AppThemeColor) -> Color {
        return Color(name.rawValue)
    }
}
