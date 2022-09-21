//
//  YouTubeTrailerTableCell.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//

import UIKit
import youtube_ios_player_helper

private struct Defaults {
    static let cellHeight: CGFloat = 200
    static let cornerRadius: CGFloat = 16
}

final class YouTubeTrailerTableCell: CreatableCell, Reusable {
    
    private lazy var playerView: YTPlayerView = {
        let player = YTPlayerView()
        player.delegate = self
        player.layer.masksToBounds = true
        player.layer.cornerRadius = Defaults.cornerRadius
        
        return player
    }()
    
    override func createUI() {
        contentView.addSubview(playerView)
        playerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
    }
}

// MARK: - ViewHeight
extension YouTubeTrailerTableCell: Configurable {
    func setup(with model: String) {
        playerView.load(withVideoId: model)
    }
}

// MARK: - ViewHeight
extension YouTubeTrailerTableCell: YTPlayerViewDelegate {

    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return .black
    }
}

// MARK: - ViewHeight
extension YouTubeTrailerTableCell {
    static var height: CGFloat {
        return Defaults.cellHeight
    }
}
