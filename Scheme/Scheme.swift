//
//  Scheme.swift
//  JJRouter
//
//  Created by Jezz on 2022/3/7.
//

import Foundation

public protocol Scheme where Self: Target {
    init?(url: URLConvertible)
}
