import Foundation
import UIKit


extension UIView {
    
    func fillSuperview(_ container: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    class func getNestedSubviews<T: UIView>(view: UIView) -> [T] {
        return view.subviews.flatMap { subView -> [T] in
            var result = getNestedSubviews(view: subView) as [T]
            if let view = subView as? T {
                result.append(view)
            }
            return result
        }
    }

    func getNestedSubviews<T: UIView>() -> [T] {
        return UIView.getNestedSubviews(view: self) as [T]
    }
    
}
