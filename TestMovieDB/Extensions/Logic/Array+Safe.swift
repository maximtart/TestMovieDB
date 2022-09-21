//
//  Array+Safe.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        get {
            return self.indices ~= index ? self[index] : nil
        } set (newValue) {
            if self.indices ~= index, let newValue = newValue {
                self[index] = newValue
            }
        }
    }
}
