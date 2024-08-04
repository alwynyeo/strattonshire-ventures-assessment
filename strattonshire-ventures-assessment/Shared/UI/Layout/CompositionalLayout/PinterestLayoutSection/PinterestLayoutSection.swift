//
//  PinterestLayoutSection.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/2/24.
//

import UIKit

protocol PinterestLayoutConfiguration {
    var imageAspectRatio: CGFloat { get }
    var title: String { get }
    var firstSubtitle: String { get }
    var secondSubtitle: String { get }
}

final class PinterestLayoutSection {
    var section: NSCollectionLayoutSection {
        let insets = NSDirectionalEdgeInsets(
            top: 0,
            leading: cellPadding,
            bottom: 8,
            trailing: cellPadding
        )
        let section = NSCollectionLayoutSection(group: customLayoutGroup)
        section.contentInsets = insets
        return section
    }

    //MARK: - Private Helpers

    private let numberOfColumns: Int
    private let layoutConfigurations: [PinterestLayoutConfiguration]
    private let spacing: CGFloat
    private let contentWidth: CGFloat

    private var cellPadding: CGFloat {
        return spacing / 2
    }

    private lazy var frames: [CGRect] = {
        return calculateFrames()
    }()

    // Padding around cells equal to the distance between cells
    private var insets: NSDirectionalEdgeInsets {
        let insets = NSDirectionalEdgeInsets(
            top: cellPadding,
            leading: cellPadding,
            bottom: cellPadding,
            trailing: cellPadding
        )
        return insets
    }

    // Max height for section
    private lazy var sectionHeight: CGFloat = {
        return (frames.map(\.maxY).max() ?? 0) + insets.bottom
    }()

    private lazy var customLayoutGroup: NSCollectionLayoutGroup = {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
            heightDimension: NSCollectionLayoutDimension.absolute(sectionHeight)
        )
        let customLayoutGroup = NSCollectionLayoutGroup.custom(layoutSize: layoutSize) { _ in
            self.frames.map { NSCollectionLayoutGroupCustomItem(frame: $0) }
        }
        return customLayoutGroup
    }()

    init(
        numberOfColumns: Int,
        layoutConfigurations: [PinterestLayoutConfiguration],
        spacing: CGFloat = 0,
        contentWidth: CGFloat
    ) {
        self.numberOfColumns = numberOfColumns
        self.layoutConfigurations = layoutConfigurations
        self.spacing = spacing
        self.contentWidth = contentWidth
    }

    private func calculateFrames() -> [CGRect] {
        var contentHeight: CGFloat = 0

        // 1
        let columnWidth = (contentWidth - 2 * cellPadding) / CGFloat(numberOfColumns)

        // 2
        let xOffset = (0..<numberOfColumns).map { CGFloat($0) * columnWidth }
        var currentColumn = 0
        var yOffset: [CGFloat] = Array(repeating: 0, count: numberOfColumns)

        // Total number of frames
        var frames: [CGRect] = []

        let titleFont = UIFont.boldSystemFont(ofSize: 20)
        let firstSubtitleFont = UIFont.systemFont(ofSize: 16)
        let secondSubtitleFont = UIFont.boldSystemFont(ofSize: 16)

        // Pre-calculate text heights
        let textHeights: [(CGFloat, CGFloat, CGFloat)] = layoutConfigurations.map {
            let titleHeight = $0.title.height(withConstrainedWidth: columnWidth - 2 * cellPadding, font: titleFont)
            let firstSubtitleHeight = $0.firstSubtitle.height(withConstrainedWidth: columnWidth - 2 * cellPadding, font: firstSubtitleFont)
            let secondSubtitleHeight = $0.secondSubtitle.height(withConstrainedWidth: columnWidth - 2 * cellPadding, font: secondSubtitleFont)
            return (titleHeight, firstSubtitleHeight, secondSubtitleHeight)
        }

        // 3
        for (index, layoutConfiguration) in layoutConfigurations.enumerated() {
            let (titleHeight, firstSubtitleHeight, secondSubtitleHeight) = textHeights[index]

            // Calculate image height
            let imageHeight = columnWidth / layoutConfiguration.imageAspectRatio

            // Calculate total height of all titles and subtitles
            let totalTextHeight = titleHeight + firstSubtitleHeight + secondSubtitleHeight

            // Calculate total cell height
            let columnHeight = imageHeight + totalTextHeight + cellPadding // Add padding between image and titles if needed

            // Сalculate the frame.
            let frame = CGRect(
                x: xOffset[currentColumn],
                y: yOffset[currentColumn],
                width: columnWidth,
                height: columnHeight
            )
            // Total frame inset between cells and along edges
                .insetBy(dx: cellPadding, dy: cellPadding)
            // Additional top and left offset to account for padding
                .offsetBy(dx: 0, dy: insets.leading)
            // 4
                .setHeight(height: columnHeight)

            frames.append(frame)

            // Calculate the height
            let columnLowestPoint = frame.maxY
            contentHeight = max(contentHeight, columnLowestPoint)
            yOffset[currentColumn] = columnLowestPoint

            // 5
            currentColumn = yOffset.indexOfMinElement ?? 0
        }
        return frames
    }
}

private extension Array where Element: Comparable {
    // Index of min element in Array
    var indexOfMinElement: Int? {
        guard count > 0 else { return nil }
        return self.enumerated().min(by: { $0.element < $1.element })?.offset
    }
}

private extension CGRect {
    func setHeight(height: CGFloat) -> CGRect {
        return CGRect(x: minX, y: minY, width: width, height: height)
    }
}

private extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return ceil(boundingBox.height)
    }
}
