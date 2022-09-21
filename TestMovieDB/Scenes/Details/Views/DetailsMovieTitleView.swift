//
//  DetailsMovieTitleView.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//

import UIKit

private struct Defaults {
    static let posterSize: CGFloat = 80
    
}

final class DetailsMovieTitleView: CreatableView {
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Defaults.posterSize / 2
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22.0, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
        
        return label
    }()
    
    private lazy var directorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .white
        
        return label
    }()
    
    override func createUI() {
        addSubview(posterView)
        posterView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview()
            $0.size.equalTo(Defaults.posterSize)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(posterView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(posterView.snp.top).offset(6)
            
        }
        
        addSubview(directorLabel)
        directorLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.bottom.equalTo(posterView.snp.bottom).inset(6)
            
        }
    }
}

// MARK: - Configurable
extension DetailsMovieTitleView: Configurable {
    struct Model {
        let poster: String
        let title: String
        let director: String
    }
    
    func setup(with model: Model) {
        setupPoster(url: model.poster)
        
        titleLabel.text = model.title
        directorLabel.text = "by \(model.director)"
    }
}

// MARK: - Private
private extension DetailsMovieTitleView {
    func setupPoster(url: String) {
        ImageService.shared.setImage(from: url) { [weak self] image in
            self?.posterView.image = image
        }
    }
}
