import Foundation
import UIKit

open class Router {
    
    @discardableResult
    open func push(_ target: Target, from navigation: UINavigationController? = nil, animated: Bool = true) -> UIViewController? {
        return nil
    }
    
    @discardableResult
    open func present(_ target: Target, from viewController: UIViewController? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return nil
    }
}
