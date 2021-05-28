import Foundation
import UIKit


protocol UINibInitProtocol {
    static func instantiate() -> Self
}

extension UINibInitProtocol where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let nib = UINib(nibName: className, bundle: Bundle.main)
        
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}
