import UIKit
import SwiftUI

public extension UIColor {
    
    static func getAppThemeColor(_ name: AppThemeColor) -> UIColor {
        return UIColor(named: name.rawValue)!
    }
}

public extension Color {
    static func getAppThemeColor(_ name: AppThemeColor) -> Color {
        return Color(name.rawValue)
    }
}
