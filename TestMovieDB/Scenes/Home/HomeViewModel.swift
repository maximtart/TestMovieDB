//
//  HomeViewModel.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

protocol HomeViewModelProtocol: AnyObject {
    var viewState: AnyPublisher<Home.Models.ViewState, Never> { get }
    var viewAction: AnyPublisher<Home.Models.ViewAction, Never> { get }
    var route: AnyPublisher<Home.Models.ViewRoute, Never> { get }

    var movies: [Home.Models.TableItemModel] { get }
    func process(input: Home.Models.ViewModelInput)
    func askMoreIfAvailable()
    
    func didSelectItem(index: Int)
}

final class HomeViewModel {
    
    // MARK: - Properties
    private let viewStateSubj = CurrentValueSubject<Home.Models.ViewState, Never>(.idle)
    private let viewActionSubj = PassthroughSubject<Home.Models.ViewAction, Never>()
    private let routeSubj = PassthroughSubject<Home.Models.ViewRoute, Never>()

    private var subscriptions = Set<AnyCancellable>()
    private var pagination = Home.Models.Pagination(page: 1, isLoading: false)
    
    var movies: [Home.Models.TableItemModel] = []
}

// MARK: - HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {

    var viewState: AnyPublisher<Home.Models.ViewState, Never> { viewStateSubj.eraseToAnyPublisher() }
    var viewAction: AnyPublisher<Home.Models.ViewAction, Never> { viewActionSubj.eraseToAnyPublisher() }
    var route: AnyPublisher<Home.Models.ViewRoute, Never> { routeSubj.eraseToAnyPublisher() }
    
    private var networkService: NetworkServiceProtocol {
        NetworkService()
    }

    
    func process(input: Home.Models.ViewModelInput) {
        input.onLoad.sink { [weak self] _ in
            self?.fetch(page: 1)
        }.store(in: &subscriptions)
    }
    
    func askMoreIfAvailable() {
        guard !pagination.isLoading else { return }
        
        pagination.page += 1
        fetch(page: pagination.page)
    }
    
    func didSelectItem(index: Int) {
        let gradient = index % GradientView.PredefinedList.allCases.count
        
        guard let movieId = movies[safe: index]?.id else {
            viewStateSubj.send(.failure(AppErrors.noMovieId.generateError()))
            return
        }
        
        routeSubj.send(.movieDetails(gradientIndex: gradient, movieId: movieId))
    }
}

// MARK: - Private
private extension HomeViewModel {
    func fetch(page: Int) {
        viewStateSubj.send(.loading)
        pagination.isLoading = true
        
        networkService.request(PopularMovieRequest(page: page), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                let newMovies: [Home.Models.TableItemModel] = movies.map {
                    .init(id: $0.id,
                          title: $0.title,
                          releaseDate: $0.releaseDate,
                          poster: $0.posterURL,
                          rating: $0.voteAverage)
                }
                page == 1 ?
                    self.movies = newMovies :
                    self.movies.append(contentsOf: newMovies)

                self.viewStateSubj.send(.loaded)
                
            case .failure(let error):
                self.viewStateSubj.send(.failure(error))
            }
            self.pagination.isLoading = false
        })
    }
}
