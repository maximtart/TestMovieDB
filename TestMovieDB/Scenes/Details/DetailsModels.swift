//
//  DetailsModels.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine
import UIKit

enum Details {}

extension Details {
    enum Models {}
}

// MARK: - Models View Input/Output
extension Details.Models {

    // MARK: Input
    struct ViewModelInput {
        let onLoad: AnyPublisher<Void, Never>
        let onWillAppear: AnyPublisher<Void, Never>
    }

    // MARK: Output
    enum ViewState {
        case idle
        case loading
        case loaded
        case empty
        case failure(Error)
    }

    enum ViewAction {
    }

    enum ViewRoute {
    }
    
    enum TableItem {
        
        case trailer(youtubeId: String)
        case overview(OverviewTableCell.Model)
        case cast(avatars: [String])
        case ratings(RatingsTableCell.Model)
    }
}

// MARK: - Screen Data
extension Details.Models {
    struct ScreenData {
        
        let title: String
        let director: String
        let poster: String
        var tableItems: [Details.Models.TableItem]
        
        static var empty: Self {
            return .init(title: "", director: "", poster: "", tableItems: [])
        }
        
        init(title: String, director: String, poster: String, tableItems: [Details.Models.TableItem] = []) {
            self.title = title
            self.director = director
            self.poster = poster
            self.tableItems = tableItems
        }
    }
}

extension Details.Models.TableItem {
    static func height(for item: Details.Models.TableItem, tableView: UITableView) -> CGFloat {
        switch item {
        case .trailer:
            return YouTubeTrailerTableCell.height
        case .overview(let model):
            return OverviewTableCell.height(for: model,
                                            for: tableView.frame.width)
        case .cast:
            return CastTableCell.height
        case .ratings:
            return RatingsTableCell.height
        }
    }
    
    static func configureCell(for indexPath: IndexPath, at tableView: UITableView, with item: Details.Models.TableItem) -> UITableViewCell {
        switch item {
            
        case .trailer(let model):
            let cell: YouTubeTrailerTableCell = tableView.dequeueAndRegisterCell(indexPath: indexPath)
            cell.setup(with: model)
            
            return cell
            
        case .overview(let model):
            let cell: OverviewTableCell = tableView.dequeueAndRegisterCell(indexPath: indexPath)
            cell.setup(with: model)
            
            return cell
        case .cast(let model):
            let cell: CastTableCell = tableView.dequeueAndRegisterCell(indexPath: indexPath)
            cell.setup(with: .init(castAvatars: model))
            return cell
        case .ratings(let model):
            let cell: RatingsTableCell = tableView.dequeueAndRegisterCell(indexPath: indexPath)
            cell.setup(with: model)
            return cell
        }
    }

}

