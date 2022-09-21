//
//  HomeViewController.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

final class HomeViewController: BaseViewController<HomeViewModelProtocol> {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22.0, weight: .bold)
        label.textColor = .black
        label.text = "Popular Movies"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.sectionHeaderTopPadding = 0
        
        table.delegate = self
        table.dataSource = self
        table.scrollsToTop = false
        
        table.estimatedSectionHeaderHeight = 80
        
        return table
    }()
    
    // MARK: - Properties
    private let onLoad = PassthroughSubject<Void, Never>()
    private let onWillAppear = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        bind(to: viewModel)
        onLoad.send(())
    }
}

// MARK: - CreatableViewProtocol
extension HomeViewController: CreatableViewProtocol {
    
    func createUI() {
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(view.snpSafeTop).offset(20)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PopularMovieTableCell = tableView.dequeueAndRegisterCell(indexPath: indexPath)
        let object = viewModel.movies[indexPath.section]
        
        let index = indexPath.section % GradientView.PredefinedList.allCases.count
        cell.setup(with: .init(gradientIndex: index,
                               title: object.title,
                               poster: object.poster,
                               rating: object.rating,
                               releaseDate: object.releaseDate)
        )
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(index: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section > viewModel.movies.count - 5 else {
            return
        }
        
        viewModel.askMoreIfAvailable()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .clear
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 20
    }
}

// MARK: - Bind
private extension HomeViewController {
    
    func bind(to viewModel: HomeViewModelProtocol) {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        
        let input = Home.Models.ViewModelInput(onLoad: onLoad.eraseToAnyPublisher(),
                                               onWillAppear: onWillAppear.eraseToAnyPublisher())
        viewModel.process(input: input)
        
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                self?.render(state)
            }).store(in: &subscriptions)
        
        viewModel.viewAction
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] action in
                self?.handleAction(action)
            }).store(in: &subscriptions)
        
        viewModel.route
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] route in
                self?.handleRoute(route)
            }).store(in: &subscriptions)
    }
    
    func render(_ state: Home.Models.ViewState) {
        switch state {
        case .loaded:
            tableView.reloadData()
        case let .failure(error):
            showError(error)
        default: ()
        }
    }
    
    func handleAction(_ action: Home.Models.ViewAction) {
        //        switch action {
        // show alert
        // scrollToTop
        // ...
        //        }
    }
    
    func handleRoute(_ route: Home.Models.ViewRoute) {
        switch route {
        case let .movieDetails(gradientIndex, movieId):
            let model = DetailsViewModel(gradientIndex: gradientIndex,
                                         movieId: movieId)
            
            let details = Details.Assembly.createModule(with: model)
            navigationController?.pushViewController(details, animated: true)
        }
    }
}
