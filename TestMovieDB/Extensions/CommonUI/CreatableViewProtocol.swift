//
//  CreatableViewProtocol.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import UIKit

public protocol CreatableViewProtocol {
    func createUI()
}

// MARK: - CreatableView
open class CreatableView: UIView, CreatableViewProtocol {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        createUI()
    }

    @objc
    open dynamic func createUI() {
        print("createUI func Not implemented")
    }
}

// MARK: - CreatableCell
open class CreatableCell: UITableViewCell, CreatableViewProtocol {

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        createUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        createUI()
    }

    open func createUI() {
        fatalError("Not implemented")
    }
}

// MARK: - CollectionCreatableCell
open class CollectionCreatableCell: UICollectionViewCell, CreatableViewProtocol {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        createUI()
    }
    
    open func createUI() {
        fatalError("Not implemented")
    }
}
