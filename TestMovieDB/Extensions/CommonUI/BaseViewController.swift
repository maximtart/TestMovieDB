//
//  BaseViewController.swift
//  TestMovieDB
//
//  Created by maxim Tartachnik on 18.09.2022.
//

import UIKit
import SnapKit

open class BaseViewController<Model>: UIViewController {
    
    // MARK: - Properties
    private var _viewModel: Model?
    
    public var viewModel: Model {
        if let viewModel = _viewModel {
            return viewModel
        } else {
            fatalError("_viewModel instance should be set")
        }
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Initializators
    public init(model: Model) {
        self._viewModel = model
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: nil, bundle: bundle)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - Common stuff
    public func showError(_ error: Error) {
        let alert = UIAlertController(title: "Oops..",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
