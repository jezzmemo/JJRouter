import Foundation
import UIKit

open class Router {
    
    public static let `default` = Router()
    
    @discardableResult
    open func push(target: Target, from navigation: UINavigationController? = nil, animated: Bool = true) -> UIViewController? {
        return nil
    }
    
    @discardableResult
    open func present(target: Target, from viewController: UIViewController? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return nil
    }
}

extension Router {
    
    public func viewController(target: Target) -> UIViewController? {
        guard let t = target as? ViewControllerTarget else {
            return nil
        }
        guard let viewController = t.viewController else { return nil }
        return viewController
    }
    
}
