//
//  ListAdsView+CollectionView.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import UIKit
import SwiftUI

extension ListAdsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    // Returns the number of ads to display
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.ads.count
    }

    // Configures each ad cell in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCollectionViewCell.identifier, for: indexPath) as? AdCollectionViewCell else {
            return UICollectionViewCell()
        }
        let ad = viewModel.ads[indexPath.row]
        let categoryName = viewModel.categories.first(where: { $0.id == ad.categoryId })?.name
        cell.configure(with: ad, categoryName: categoryName ?? "")
        return cell
    }

    // Handles tap events when an ad is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ad = viewModel.ads[indexPath.row]
        let adDetailView = AdDetailView(ad: ad, categoryName: viewModel.categories.first(where: { $0.id == ad.categoryId })?.name ?? "")
        let hostingController = UIHostingController(rootView: adDetailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
