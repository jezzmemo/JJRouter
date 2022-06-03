//
//  DemoAScheme.swift
//  JJRouter_Example
//
//  Created by Jezz on 2022/4/12.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import JJRouter

public class DemoAScheme: Scheme {
    
    public required init?(url: URLConvertible) {
        switch url.pattern {
        case "111":
            break
        default:
            return nil
        }
        return nil
    }
    
    public var viewController: UIViewController? {
        return nil
    }
    
    
}

