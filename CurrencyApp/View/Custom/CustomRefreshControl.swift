import Foundation
import UIKit


class CustomRefreshControl: UIRefreshControl {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let l = getNestedSubviews().first(where: { $0.layer is CAReplicatorLayer }),
           l.subviews.count > 0 {
            l.subviews[0].backgroundColor = tintColor
        }
    }
}
