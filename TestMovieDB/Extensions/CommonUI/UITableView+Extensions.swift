//
//  UITableView+Extensions.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import UIKit
extension UITableView {
    func dequeueAndRegisterCell<Cell>(indexPath: IndexPath) -> Cell
    where Cell: UITableViewCell & Reusable {
        register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        return dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
    }
}
