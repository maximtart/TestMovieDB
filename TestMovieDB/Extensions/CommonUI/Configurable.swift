//
//  Configurable.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import Foundation

public protocol Configurable {
    associatedtype Model
    func setup(with model: Model)
}
