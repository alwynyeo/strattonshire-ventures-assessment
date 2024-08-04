//
//  ListMoviesViewController.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//

import UIKit

final class ListMoviesViewController: UICollectionViewController {
    // MARK: - Declarations

    var viewModel: ListMoviesBusinessLogic?

    private let refreshControl = UIRefreshControl()

    // MARK: - Object Lifecycle

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    convenience init() {
        let collectionViewLayout = UICollectionViewLayout()
        self.init(collectionViewLayout: collectionViewLayout)
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
        viewModel?.dataSource = makeDataSource()
        collectionView.startLoading()
        viewModel?.loadAllMovies()
    }

    // MARK: - Override Parent Methods

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.routeToDetailMovie(indexPath: indexPath)
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffsetY = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.height
        let scrollThresholdY = totalContentHeight - visibleHeight

        let isNearBottom = currentOffsetY > scrollThresholdY

        guard isNearBottom else { return }

        if !collectionView.isLoading {
            collectionView.startLoading(for: UIView.ActivityIndicatorType.pagination)
        }

        viewModel?.loadNextPageOfMovies()
    }

    // MARK: - Setup

    private func setUp() {
        let viewController = self
        let networkService = NetworkService.shared
        let persistenceService = PersistenceService.shared
        let viewModel = ListMoviesViewModel(
            view: viewController,
            networkService: networkService, 
            persistenceService: persistenceService
        )
        viewController.viewModel = viewModel
    }

    // MARK: - Helpers
    func makeDataSource() -> ListMoviesViewControllerDataSource {
        let dataSource = ListMoviesViewControllerDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let defaultCell = UICollectionViewCell()
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListMovieCell.cellId,
                for: indexPath
            ) as? ListMovieCell else {
                return defaultCell
            }
            cell.configure(item: item)
            return cell
        }

        return dataSource
    }


    private func configureLayout(layoutConfigurations: [PinterestLayoutConfiguration]) {
        let layout = CustomCompositionalLayout.layout(
            layoutConfigurations: layoutConfigurations,
            contentWidth: collectionView.bounds.width
        )
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func refreshMovieList() {
        viewModel?.refreshMovieList()
    }
}

// MARK: - ListMoviesDisplayLogic Extension
extension ListMoviesViewController: ListMoviesDisplayLogic {
    func displayLoadedMovies(layoutConfigurations: [PinterestLayoutConfiguration]) {
        if collectionView.isLoading { self.collectionView.stopLoading() }
        if refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
        configureLayout(layoutConfigurations: layoutConfigurations)
    }

    func stopLoading() {
        guard collectionView.isLoading else { return }
        collectionView.stopLoading()
    }

    func routeToDetailMovie(intent: DetailMovieIntent) {
        let detailMovieViewController = DetailMovieViewController()
        detailMovieViewController.intent = intent
        navigationController?.pushViewController(detailMovieViewController, animated: true)
    }
}

extension ListMoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let queryText = searchController.searchBar.text else { return }
        guard queryText.isNotEmpty else {
            viewModel?.clearSearchResults()
            return
        }

        let isSameQuery = viewModel?.isSameQuery ?? false

        if !isSameQuery {
            collectionView.startLoading(for: UIView.ActivityIndicatorType.normal)
        }

        viewModel?.filterMovies(by: queryText)
    }
}

// MARK: - Programmatic UI Configuration
private extension ListMoviesViewController {
    func configureUI() {
        view.backgroundColor = Resources.Color.backgroundColor
        configureNavigationBar()
        configureSearchController()
        configureCollectionView()
        configureRefreshControl()
    }

    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Home"
    }

    func configureSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        navigationItem.searchController = search
    }

    func configureCollectionView() {
        collectionView.dataSource = viewModel?.dataSource
        collectionView.backgroundColor = Resources.Color.backgroundColor
        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(
            ListMovieCell.self,
            forCellWithReuseIdentifier: ListMovieCell.cellId
        )
    }

    func configureRefreshControl() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.refreshMovieList()
        }
        refreshControl.addAction(action, for: UIControl.Event.valueChanged)
        collectionView.refreshControl = refreshControl
    }
}
