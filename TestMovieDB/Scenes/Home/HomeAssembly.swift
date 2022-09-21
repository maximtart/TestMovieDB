//
//  HomeAssembly.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

extension Home {
    enum Assembly {}
}

extension Home.Assembly {
    static func createModule(with viewModel: HomeViewModelProtocol) -> UIViewController {
        let viewController = HomeViewController(model: viewModel)
        return viewController
    }
}
