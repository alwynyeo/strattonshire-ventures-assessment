//
//  ListMovieCell.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//

import UIKit

final class ListMovieCell: UICollectionViewCell {
    // MARK: - Declarations

    private var item: ListMovieCellItem? {
        didSet { configureItem() }
    }

    static let cellId = "ListMovieCellId"

    private let posterImageView = UIImageView()
    private let mainVerticalStackView = UIStackView()
    private let subHorizontalStackView = UIStackView()

    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let ratingLabel = UILabel()

    // MARK: - Object Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    // MARK: - Override Parent Methods

    override func prepareForReuse() {
        super.prepareForReuse()
        clearCache()
    }

    // MARK: - Helpers

    func configure(item: ListMovieCellItem) {
        self.item = item
    }

    private func configureItem() {
        guard let movie = item?.movie else { return }
        let title = movie.title ?? ""
        let year = movie.year ?? 0
        let rating = movie.rating ?? 0

        if let posterUrlString = movie.poster {
            posterImageView.setImage(with: posterUrlString)
        }
        
        titleLabel.text = title
        yearLabel.text = "\(year)"
        ratingLabel.text = "\(rating)"
    }

    private func clearCache() {
        posterImageView.image = nil
        titleLabel.text = nil
        yearLabel.text = nil
        ratingLabel.text = nil
    }
}

// MARK: - Programmatic UI Configuration
private extension ListMovieCell {
    func configureUI() {
        backgroundColor = Resources.Color.cellBackgroundColor
        layer.cornerRadius = 8.0
        configurePosterImageView()
        configureTitleLabel()
        configureYearLabel()
        configureRatingLabel()
        configureSubHorizontalStackView()
        configureMainVerticalStackView()
    }

    func configurePosterImageView() {
        posterImageView.contentMode = UIView.ContentMode.scaleAspectFill
        posterImageView.layer.cornerRadius = 8.0
        posterImageView.layer.maskedCorners = [
            CACornerMask.layerMinXMinYCorner,
            CACornerMask.layerMaxXMinYCorner,
        ]
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(posterImageView)

        let constraints = [
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Resources.Color.text
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.setContentCompressionResistancePriority(
            UILayoutPriority.required,
            for: NSLayoutConstraint.Axis.vertical
        )
    }

    func configureYearLabel() {
        yearLabel.numberOfLines = 0
        yearLabel.textColor = Resources.Color.text
        yearLabel.font = UIFont.systemFont(ofSize: 16)
        yearLabel.textAlignment = NSTextAlignment.left
    }

    func configureRatingLabel() {
        ratingLabel.numberOfLines = 0
        ratingLabel.textColor = Resources.Color.red
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 16)
        ratingLabel.textAlignment = NSTextAlignment.right
    }

    func configureSubHorizontalStackView() {
        subHorizontalStackView.axis = NSLayoutConstraint.Axis.horizontal
        subHorizontalStackView.spacing = 8.0
        subHorizontalStackView.alignment = UIStackView.Alignment.fill
        subHorizontalStackView.distribution = UIStackView.Distribution.fillEqually
        subHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        subHorizontalStackView.addArrangedSubview(yearLabel)
        subHorizontalStackView.addArrangedSubview(ratingLabel)
    }

    func configureMainVerticalStackView() {
        mainVerticalStackView.axis = NSLayoutConstraint.Axis.vertical
        mainVerticalStackView.spacing = 8.0
        mainVerticalStackView.alignment = UIStackView.Alignment.fill
        mainVerticalStackView.distribution = UIStackView.Distribution.fill
        mainVerticalStackView.translatesAutoresizingMaskIntoConstraints = false

        mainVerticalStackView.addArrangedSubview(titleLabel)
        mainVerticalStackView.addArrangedSubview(subHorizontalStackView)

        contentView.addSubview(mainVerticalStackView)

        let constraints = [
            mainVerticalStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
