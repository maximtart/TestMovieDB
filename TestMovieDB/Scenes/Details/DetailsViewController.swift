//
//  DetailsViewController.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

private struct Defaults {
    static let titleViewHeight: CGFloat = 90
}

final class DetailsViewController: BaseViewController<DetailsViewModelProtocol> {

    private lazy var gradientView: GradientView = {
        let listCase = GradientView.PredefinedList.allCases[viewModel.gradientIndex]
        
        let gradient = listCase.createView()
        gradient.direction = .vertical
        
        return gradient
    }()
    
    private lazy var titleView = DetailsMovieTitleView()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.sectionHeaderTopPadding = 0
        
        table.delegate = self
        table.dataSource = self
        table.scrollsToTop = false
        
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
extension DetailsViewController: CreatableViewProtocol {

    func createUI() {
        view.addSubview(gradientView)
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.snpSafeTop)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Defaults.titleViewHeight)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate
extension DetailsViewController: UITableViewDelegate {
}

// MARK: - UITableViewDataSource
extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.screenData.tableItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.screenData.tableItems[indexPath.row]
        
        return Details.Models.TableItem.height(for: item, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.screenData.tableItems[indexPath.row]
        
        return Details.Models.TableItem.height(for: item, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return Details.Models.TableItem
            .configureCell(for: indexPath,
                           at: tableView,
                           with: viewModel.screenData.tableItems[indexPath.row])
    }
}

// MARK: - Bind
private extension DetailsViewController {

    func bind(to viewModel: DetailsViewModelProtocol) {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()

        let input = Details.Models.ViewModelInput(onLoad: onLoad.eraseToAnyPublisher(),
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

    func render(_ state: Details.Models.ViewState) {
        switch state {
        case .loaded:
            titleView.setup(with: .init(poster: viewModel.screenData.poster,
                                        title: viewModel.screenData.title,
                                        director: viewModel.screenData.director))
            tableView.reloadData()
        case let .failure(error):
            showError(error)
        default: ()
        }
    }

    func handleAction(_ action: Details.Models.ViewAction) {
//        switch action {
            // show alert
            // scrollToTop
            // ...
//        }
    }

    func handleRoute(_ route: Details.Models.ViewRoute) {
//        switch route {
//        }
    }
}
