//
//  RatingsTableCell.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//

import UIKit

private struct Defaults {
    static let cellHeight: CGFloat = 100
    enum RatingsKind {
        case popularity(Int)
        case votes(Int)
        
        var value: Int {
            switch self {
            case .votes(let value), .popularity(let value):
                return value
            }
        }
        var title: String {
            switch self {
            case .votes:
                return "Votes"
            case .popularity:
                return "Popularity"
            }
        }
        
        var ofCount: String {
            switch self {
            case .votes:
                return ""
            case .popularity:
                return "/10 000"
            }
        }
    }
}

final class RatingsTableCell: CreatableCell, Reusable {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22.0, weight: .medium)
        label.textColor = .white
        label.text = "Ratings"
        return label
    }()
    
    private lazy var voteCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var popularityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func createUI() {
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(popularityLabel)
        popularityLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(60)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(voteCountLabel)
        voteCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(60)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}

// MARK: - ViewHeight
extension RatingsTableCell: Configurable {
    struct Model {
        let popularity: Double
        let votes: Int
    }
    
    func setup(with model: Model) {
        setupRatings(kind: .popularity(Int(model.popularity)),
                     on: popularityLabel)
        setupRatings(kind: .votes(model.votes),
                     on: voteCountLabel)
    }
    
    private func setupRatings(kind: Defaults.RatingsKind, on label: UILabel) {
        var attr: [NSAttributedString.Key : Any]? = [
            .font : UIFont.systemFont(ofSize: 14.0, weight: .medium),
            .foregroundColor : UIColor.white
        ]
        let firstPart = NSMutableAttributedString(string: kind.title,
                                                  attributes: attr)
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 5
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        shadow.shadowColor = UIColor.black
        
        attr = [
            .font : UIFont.systemFont(ofSize: 27.0, weight: .medium),
            .foregroundColor : UIColor.white,
            .shadow : shadow
        ]
        let secondPart = NSMutableAttributedString(string: "\n\(kind.value)",
                                                   attributes: attr)
        
        attr = [
            .font : UIFont.systemFont(ofSize: 14.0, weight: .medium),
            .foregroundColor : UIColor.white,
            .shadow : shadow
        ]
        let thirdPart = NSMutableAttributedString(string: kind.ofCount,
                                                   attributes: attr)
        
        firstPart.append(secondPart)
        firstPart.append(thirdPart)
        
        label.attributedText = firstPart
    }
}

// MARK: - ViewHeight
extension RatingsTableCell {
    static var height: CGFloat {
        return Defaults.cellHeight
    }
}
