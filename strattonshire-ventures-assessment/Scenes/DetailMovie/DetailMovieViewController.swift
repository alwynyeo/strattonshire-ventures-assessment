//
//  DetailMovieViewController.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/4/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - DetailMovieViewController Class
final class DetailMovieViewController: UIViewController {
    // MARK: - Declarations

    var viewModel: DetailMovieViewModel?

    var intent: DetailMovieIntent?

    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let genreLabel = UILabel()
    private let ratingLabel = UILabel()
    private let directorLabel = UILabel()
    private let actorLabel = UILabel()
    private let plotLabel = UILabel()
    private let runtimeLabel = UILabel()
    private let awardsLabel = UILabel()
    private let countryLabel = UILabel()
    private let languageLabel = UILabel()
    private let boxOfficeLabel = UILabel()
    private let productionLabel = UILabel()
    private let websiteLabel = UILabel()
    private var labels: [UILabel] = []
    private let stackView = UIStackView()

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
        print("Deinit DetailMovieViewController")
    }

    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        configureUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.intent = intent
        displayMovie()
    }

    // MARK: - Override Parent Methods

    // MARK: - Setup

    private func setUp() {
        let viewController = self
        let viewModel = DetailMovieViewModel(
            view: viewController
        )
        viewController.viewModel = viewModel
    }

    // MARK: - Helpers
    private func displayMovie() {
        let movie = intent?.movie

        if let posterUrlString = movie?.poster {
            posterImageView.setImage(with: posterUrlString)
        }

        let title = movie?.title ?? ""
        let year = movie?.year ?? 0
        let genres = movie?.genres?.joined(separator: ", ") ?? ""
        let rating = movie?.rating ?? 0
        let director = movie?.director ?? ""
        let actors = movie?.actors?.joined(separator: ", ") ?? ""
        let plot = movie?.plot ?? ""
        let runtime = movie?.runtime ?? 0
        let awards = movie?.awards ?? ""
        let country = movie?.country ?? ""
        let language = movie?.language ?? ""
        let boxOffice = movie?.boxOffice ?? ""
        let production = movie?.production ?? ""
        let website = movie?.website ?? ""

        titleLabel.text = "Title: \(title)"
        yearLabel.text = "Year: \(year)"
        genreLabel.text = "Genre: \(genres)"
        ratingLabel.text = "Rating: \(rating)"
        directorLabel.text = "Director: \(director)"
        actorLabel.text = "Actors: \(actors)"
        plotLabel.text = "Plot: \(plot)"
        runtimeLabel.text = "Runtime: \(runtime)"
        awardsLabel.text = "Awards: \(awards)"
        countryLabel.text = "Country: \(country)"
        languageLabel.text = "Language: \(language)"
        boxOfficeLabel.text = "Box Office: \(boxOffice)"
        productionLabel.text = "Production: \(production)"
        websiteLabel.text = "Website: \(website)"

        if title.isNotEmpty { titleLabel.isHidden = false }
        if year != 0 { yearLabel.isHidden = false }
        if genres.isNotEmpty { genreLabel.isHidden = false }
        if rating != 0 { ratingLabel.isHidden = false }
        if director.isNotEmpty { directorLabel.isHidden = false }
        if actors.isNotEmpty { actorLabel.isHidden = false }
        if plot.isNotEmpty { plotLabel.isHidden = false }
        if runtime != 0 { runtimeLabel.isHidden = false  }
        if awards.isNotEmpty { awardsLabel.isHidden = false  }
        if country.isNotEmpty {countryLabel.isHidden = false  }
        if language.isNotEmpty { languageLabel.isHidden = false }
        if boxOffice.isNotEmpty { boxOfficeLabel.isHidden = false }
        if production.isNotEmpty { productionLabel.isHidden = false }
        if website.isNotEmpty { websiteLabel.isHidden = false }
    }
}

// MARK: - DetailMovieDisplayLogic Extension
extension DetailMovieViewController: DetailMovieDisplayLogic {}

// MARK: - Programmatic UI Configuration
private extension DetailMovieViewController {
    func configureUI() {
        view.backgroundColor = Resources.Color.backgroundColor
        configureNavigationBar()
        configureScrollView()
        configureScrollContentView()
        configurePosterImageView()
        configureLabels()
        configureStackView()
    }

    func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.never
        title = intent?.movie.title ?? ""
    }

    func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(scrollContentView)

        view.addSubview(scrollView)

        let constraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureScrollContentView() {
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false

        scrollContentView.addSubview(posterImageView)
        scrollContentView.addSubview(stackView)

        let constraints = [
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configurePosterImageView() {
        posterImageView.contentMode = UIView.ContentMode.scaleToFill
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            posterImageView.topAnchor.constraint(equalTo: scrollContentView.safeAreaLayoutGuide.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: scrollContentView.safeAreaLayoutGuide.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: scrollContentView.safeAreaLayoutGuide.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.32),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureLabels() {
        titleLabel.isHidden = true
        yearLabel.isHidden = true
        genreLabel.isHidden = true
        ratingLabel.isHidden = true
        directorLabel.isHidden = true
        actorLabel.isHidden = true
        plotLabel.isHidden = true
        runtimeLabel.isHidden = true
        awardsLabel.isHidden = true
        countryLabel.isHidden = true
        languageLabel.isHidden = true
        boxOfficeLabel.isHidden = true
        productionLabel.isHidden = true
        websiteLabel.isHidden = true

        let labels = [
            titleLabel,
            yearLabel,
            genreLabel,
            ratingLabel,
            directorLabel,
            actorLabel,
            plotLabel,
            runtimeLabel,
            awardsLabel,
            countryLabel,
            languageLabel,
            boxOfficeLabel,
            productionLabel,
            websiteLabel,
        ]

        labels.forEach {
            $0.numberOfLines = 0
            self.labels.append($0)
        }
    }

    func configureStackView() {
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 8.0
        stackView.alignment = UIStackView.Alignment.fill
        stackView.distribution = UIStackView.Distribution.fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        labels.forEach {
            stackView.addArrangedSubview($0)
        }

        let constraints = [
            stackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -8),
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
