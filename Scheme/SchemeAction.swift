//
//  SchemeAction.swift
//  JJRouter
//
//  Created by Jezz on 2022/4/4.
//

import Foundation

protocol SchemeAction {
    
    func register(scheme: Scheme.Type)
    
    func viewController(url: URLConvertible) -> UIViewController?
}
