//
//  Router+SchemeAction.swift
//  JJRouter
//
//  Created by Jezz on 2022/4/4.
//

import Foundation

private var routeTargetsKey = "routeTargetsKey"

extension Router: SchemeAction {
    
    public var routeTargets: [Scheme.Type] {
        get { return objc_getAssociatedObject(self, &routeTargetsKey) as? [Scheme.Type] ?? [] }
        set { objc_setAssociatedObject(self, &routeTargetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func register(scheme: Scheme.Type) {
        routeTargets.append(scheme)
    }
    
    func viewController(url: URLConvertible) -> UIViewController? {
        return nil
    }
    
}
