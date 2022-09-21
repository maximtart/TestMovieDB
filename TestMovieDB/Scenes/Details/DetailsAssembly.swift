//
//  DetailsAssembly.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 19.09.2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

extension Details {
    enum Assembly {}
}

extension Details.Assembly {
    static func createModule(with viewModel: DetailsViewModelProtocol) -> UIViewController {
        let viewController = DetailsViewController(model: viewModel)
        return viewController
    }
}
