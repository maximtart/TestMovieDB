//
//  PopularMovieTableCell.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import UIKit

private struct Defaults {
    static let pesterCornerRadius: CGFloat = 6
    static let gradientCornerRadius: CGFloat = 20
    static let posterWidth: CGFloat = 60
}

final class PopularMovieTableCell: CreatableCell, Reusable {
    
    private var gradientView: GradientView = {
        let gradient = GradientView.PredefinedList.mauve.createView()
        gradient.layer.cornerRadius = Defaults.gradientCornerRadius
        
        return gradient
    }()
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Defaults.pesterCornerRadius
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
        
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterView.image = nil
    }
    
    override func createUI() {
        contentView.addSubview(gradientView)
        gradientView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        gradientView.addSubview(posterView)
        posterView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(12)
            $0.width.equalTo(Defaults.posterWidth)
        }
        
        gradientView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(posterView.snp.trailing).offset(10)
            $0.top.equalTo(posterView.snp.top).offset(6)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        gradientView.addSubview(releaseDateLabel)
        releaseDateLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.bottom.equalTo(posterView.snp.bottom).inset(6)
        }
        
        gradientView.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(releaseDateLabel.snp.centerY)
        }
        
    }
}

// MARK: - Configurable
extension PopularMovieTableCell: Configurable, RatingLabel {
    
    struct Model {
        let gradientIndex: Int
        let title: String
        let poster: String
        let rating: Double
        let releaseDate: Date
    }
    
    func setup(with model: Model) {
        refreshGradient(index: model.gradientIndex)
        setupPoster(url: model.poster)
        
        titleLabel.text = model.title
        setupRelease(date: model.releaseDate)
        setupRating(model.rating, on: ratingLabel)
        
    }
}

// MARK: - Private
private extension PopularMovieTableCell {
    func refreshGradient(index: Int) {
        let listCase = GradientView.PredefinedList.allCases[safe: index] ?? .mauve
        gradientView.startColor = listCase.startColor
        gradientView.endColor = listCase.endColor
    }
    
    func setupRelease(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        
        releaseDateLabel.text = "Release: \(dateFormatter.string(from: date))"
    }
    
    func setupPoster(url: String) {
        
        ImageService.shared.setImage(from: url) { [weak self] image in
            self?.posterView.image = image
        }
    }
}
