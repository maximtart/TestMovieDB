//
//  UIView+SnapKit.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import Foundation
import SnapKit

extension UIView {
    
    var snpSafeTop: ConstraintItem {
        return safeAreaLayoutGuide.snp.top
    }
    
    var snpSafeBottom: ConstraintItem {
        return safeAreaLayoutGuide.snp.bottom
    }
}
