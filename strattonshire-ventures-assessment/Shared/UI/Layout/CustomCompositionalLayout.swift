//
//  CustomCompositionalLayout.swift
//  strattonshire-ventures-assessment
//
//  Created by Alwyn Yeo on 8/3/24.
//

import UIKit

final class CustomCompositionalLayout {
    static func layout(layoutConfigurations: [PinterestLayoutConfiguration], contentWidth: CGFloat) -> UICollectionViewCompositionalLayout {
        let section = pinterestLayoutSection(
            layoutConfigurations: layoutConfigurations,
            contentWidth: contentWidth
        )

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = UICollectionView.ScrollDirection.vertical

        let layout = UICollectionViewCompositionalLayout(
            section: section,
            configuration: config
        )

        return layout
    }

    private static func pinterestLayoutSection(
        layoutConfigurations: [PinterestLayoutConfiguration],
        contentWidth: CGFloat
    ) -> NSCollectionLayoutSection {
        let pinterestLayoutSection = PinterestLayoutSection(
            numberOfColumns: 2,
            layoutConfigurations: layoutConfigurations,
            spacing: 10,
            contentWidth: contentWidth
        )

        let section = pinterestLayoutSection.section

        return section
    }
}
