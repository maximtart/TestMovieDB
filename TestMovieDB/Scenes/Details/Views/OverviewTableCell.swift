//
//  OverviewTableCell.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//

import UIKit

private struct Defaults {
    static let overviewFont: UIFont = .systemFont(ofSize: 14.0)
    static let overviewOffset: CGFloat = 60
    static let overviewWidthOffset: CGFloat = 40
}

final class OverviewTableCell: CreatableCell, Reusable {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22.0, weight: .medium)
        label.textColor = .white
        label.text = "Overview"
        return label
    }()
    
    lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = Defaults.overviewFont
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .white
        
        return label
    }()
    
    override func createUI() {
        contentView.addSubview(titleLabel)
        self.layer.masksToBounds = true
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $00.centerY.equalTo(titleLabel)
        }
        
        contentView.addSubview(overviewLabel)
        overviewLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
}

// MARK: - ViewHeight
extension OverviewTableCell: Configurable, RatingLabel {
    struct Model {
        let overview: String
        let rating: Double
    }
    
    func setup(with model: Model) {
        overviewLabel.text = model.overview
        setupRating(model.rating, on: ratingLabel)
    }
}

// MARK: - ViewHeight
extension OverviewTableCell {
    static func height(for model: Model, for width: CGFloat) -> CGFloat {
        
        return model.overview.height(withConstrainedWidth: width - Defaults.overviewWidthOffset,
                                     font: Defaults.overviewFont)
    }
}

private extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height) + Defaults.overviewOffset
    }
}
