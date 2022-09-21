//
//  UILabel+Rating.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//

import UIKit

protocol RatingLabel {
    func setupRating(_ rating: Double, on label: UILabel)
}

extension RatingLabel {
    func setupRating(_ rating: Double, on label: UILabel) {
        let imageAttachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(pointSize: label.font.pointSize)
        let image = UIImage(systemName: "star.fill", withConfiguration: config)?.withTintColor(.systemYellow)
        
        imageAttachment.image = image
        
        let fullString = NSMutableAttributedString()
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " \(rating)"))
        label.attributedText = fullString
        
    }
}
