//
//  CastTableCell.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//

import UIKit

private struct Defaults {
    static let cellHeight: CGFloat = 120
    static let minimumSpace: CGFloat = 10
}

final class CastTableCell: CreatableCell, Reusable {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22.0, weight: .medium)
        label.textColor = .white
        label.text = "Actors"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Defaults.minimumSpace
        layout.minimumInteritemSpacing = Defaults.minimumSpace
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        
        return collection
    }()
    
    private var castAvatars: [String] = []
    
    override func createUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Configurable
extension CastTableCell: Configurable {
    struct Model {
        let castAvatars: [String]
    }
    
    func setup(with model: Model) {
        self.castAvatars = model.castAvatars
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CastTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return castAvatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CastPersonCollectionCell = collectionView.dequeueAndRegisterCell(indexPath: indexPath)
        let obj = castAvatars[indexPath.row]
        cell.setup(with: obj)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: CastPersonCollectionCell.height,
                     height: CastPersonCollectionCell.height)
    }
}

// MARK: - ViewHeight
extension CastTableCell {
    static var height: CGFloat {
        return Defaults.cellHeight
    }
}
