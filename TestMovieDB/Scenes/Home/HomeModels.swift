//
//  HomeModels.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

enum Home {}

extension Home {
    enum Models {}
}

// MARK: - Models View Input/Output
extension Home.Models {

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
        case movieDetails(gradientIndex: Int, movieId: Int)
    }
    
    struct Pagination {
        var page: Int
        var isLoading: Bool
    }
}

// MARK: - TableItemModel
extension Home.Models {
    struct TableItemModel {
        let id: Int
        let title: String
        let releaseDate: Date
        let poster: String
        let rating: Double
    }
}
