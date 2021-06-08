import Foundation
import UIKit
import SwiftUI


extension View {
    
    func buildVC() -> UIViewController {
        let hosting = UIHostingController(rootView: self)
        let c = UIViewController()
        
        c.addChild(hosting)
        hosting.view.fillSuperview(c.view)
        
        return c
    }
    
}
