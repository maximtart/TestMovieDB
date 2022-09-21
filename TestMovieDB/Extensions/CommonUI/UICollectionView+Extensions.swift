//
//  UICollectionView+Extensions.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//

import UIKit
extension UICollectionView {
    func registerCell<Cell>(type: Cell.Type) where Cell: UICollectionViewCell & Reusable {
        register(type, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func dequeueAndRegisterCell<Cell>(
        indexPath: IndexPath
    ) -> Cell where Cell: UICollectionViewCell & Reusable {
        registerCell(type: Cell.self)
        return dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
    }
}
