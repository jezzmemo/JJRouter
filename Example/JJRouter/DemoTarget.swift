//
//  DemoTarget.swift
//  JJRouter_Example
//
//  Created by Jezz on 2022/6/3.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import JJRouter

// Header
enum DemoTarget: Target {
    case login
}

// Implement
extension DemoTarget: ViewControllerTarget {
    
    var viewController: UIViewController? {
        switch self {
        case .login:
            return nil
        }
    }
    
}
