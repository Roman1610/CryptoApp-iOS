import Foundation
import UIKit


protocol UINibInitProtocol {
    static func instantiate() -> Self
}

extension UINibInitProtocol where Self: UIViewController {
    static func instantiate() -> Self {
        debugPrint("UINibInitProtocol: className - \(String(describing: self))")
        
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        let instances = nib.instantiate(withOwner: self, options: nil)
        return instances.first as! Self
    }
}
