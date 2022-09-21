//
//  Reusable.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import UIKit

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
