//
//  Target.swift
//  JJRouter
//
//  Created by Jezz on 2022/3/7.
//

import Foundation
import UIKit

public protocol Target {
    
}

public protocol ViewControllerTarget {
    var viewController: UIViewController? { get }
}
