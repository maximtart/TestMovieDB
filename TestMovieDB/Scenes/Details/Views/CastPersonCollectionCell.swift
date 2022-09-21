//
//  CastPersonCollectionCell.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//

import UIKit

private struct Defaults {
    static let previewSize: CGFloat = 60
}

final class CastPersonCollectionCell: CollectionCreatableCell, Reusable {
    
    private let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Defaults.previewSize / 2
        
        return imageView
    }()
    
    override func createUI() {
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Configurable
extension CastPersonCollectionCell: Configurable {
    
    func setup(with model: String) {
        ImageService.shared.setImage(from: model) { [weak self] image in
            self?.avatar.image = image
        }
    }
}

// MARK: - ViewHeight
extension CastPersonCollectionCell {
    static var height: CGFloat {
        return Defaults.previewSize
    }
}
