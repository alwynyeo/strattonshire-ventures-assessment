//
//  ListMoviesViewController.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//

import UIKit

protocol ListMoviesDisplayLogic: AnyObject {
    func displaySomething()
}

final class ListMoviesViewController: UIViewController {
    // MARK: - Declarations

    var viewModel: ListMoviesBusinessLogic?

    // MARK: - Object Lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    deinit {
        print("Deinit ListMoviesViewController")
    }

    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        configureUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch movie api
        viewModel?.doSomething()
    }

    // MARK: - Override Parent Methods

    // MARK: - Setup

    private func setUp() {
        let viewController = self
        let viewModel = ListMoviesViewModel()
        viewModel.view = viewController
        viewController.viewModel = viewModel
    }

    // MARK: - Helpers
}

// MARK: - ListMoviesDisplayLogic Extension
extension ListMoviesViewController: ListMoviesDisplayLogic {
    func displaySomething() {
        print("calling from view model")
    }
}

// MARK: - Programmatic UI Configuration
private extension ListMoviesViewController {
    func configureUI() {
        view.backgroundColor = Resources.Color.screenBackgroundColor
    }
}
