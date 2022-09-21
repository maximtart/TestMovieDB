//
//  DetailsViewModel.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

private struct Defaults {
    static let randomYouTubeId = "3Xv1mJvwXok"
}

protocol DetailsViewModelProtocol: AnyObject {
    var viewState: AnyPublisher<Details.Models.ViewState, Never> { get }
    var viewAction: AnyPublisher<Details.Models.ViewAction, Never> { get }
    var route: AnyPublisher<Details.Models.ViewRoute, Never> { get }
    var gradientIndex: Int { get }
    var screenData: Details.Models.ScreenData { get }
    
    func process(input: Details.Models.ViewModelInput)
}

final class DetailsViewModel {
    
    // MARK: - Properties
    private let viewStateSubj = CurrentValueSubject<Details.Models.ViewState, Never>(.idle)
    private let viewActionSubj = PassthroughSubject<Details.Models.ViewAction, Never>()
    private let routeSubj = PassthroughSubject<Details.Models.ViewRoute, Never>()

    private var subscriptions = Set<AnyCancellable>()
    
    var gradientIndex: Int
    let movieId: Int
    var screenData: Details.Models.ScreenData = .empty
    
    init(gradientIndex: Int, movieId: Int) {
        self.gradientIndex = gradientIndex
        self.movieId = movieId
    }
}

// MARK: - DetailsViewModelProtocol
extension DetailsViewModel: DetailsViewModelProtocol {

    var viewState: AnyPublisher<Details.Models.ViewState, Never> { viewStateSubj.eraseToAnyPublisher() }
    var viewAction: AnyPublisher<Details.Models.ViewAction, Never> { viewActionSubj.eraseToAnyPublisher() }
    var route: AnyPublisher<Details.Models.ViewRoute, Never> { routeSubj.eraseToAnyPublisher() }

    private var networkService: NetworkServiceProtocol {
        NetworkService()
    }

    func process(input: Details.Models.ViewModelInput) {
        input.onLoad.sink { [weak self] _ in
            self?.fetch()
        }.store(in: &subscriptions)
    }
}

// MARK: - Private
private extension DetailsViewModel {
    func fetch() {
        viewStateSubj.send(.loading)
        
        networkService.request(MovieDetailsRequest(movieId: movieId), completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let director = data.credits.crew.first { $0.job == .director }
                let youtubeId = data.videos.results.first { $0.site == .youtube }?.key ?? Defaults.randomYouTubeId
                
                let castAvatars = data.credits.cast.map{ $0.avatarURL }
                
                let items: [Details.Models.TableItem] = [
                    .trailer(youtubeId: youtubeId),
                    .overview(.init(overview: data.overview,
                                    rating: data.voteAverage)),
                    .cast(avatars: castAvatars),
                    .ratings(.init(popularity: data.popularity,
                                   votes: data.voteCount))
                  ]
                
                self.screenData =
                    .init(title: data.originalTitle,
                          director: director?.name ?? "Unknown",
                          poster: data.posterURL,
                          tableItems: items)
                
                self.viewStateSubj.send(.loaded)
            case .failure(let error):
                self.viewStateSubj.send(.failure(error))
            }
        })
    }
}
