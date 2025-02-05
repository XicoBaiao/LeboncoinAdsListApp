//
//  ListAdsView+CollectionViews.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import UIKit
import SwiftUI

extension ListAdsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return viewModel.categories.count
        } else {
            return viewModel.filteredAds.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            return configureCategoryCell(collectionView, indexPath: indexPath)
        } else {
            return configureAdCell(collectionView, indexPath: indexPath)
        }
    }
    
    // MARK: - UICollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let selectedCategory = viewModel.categories[indexPath.row]
            viewModel.selectedCategoryId = selectedCategory.id
            
            DispatchQueue.main.async {
                self.collectionView.setContentOffset(.zero, animated: true) // Scroll to top
            }
        } else {
            let ad = viewModel.filteredAds[indexPath.row]
            let categoryName = viewModel.categories.first(where: { $0.id == ad.categoryId })?.name ?? ""
            let adDetailView = AdDetailView(ad: ad, categoryName: categoryName)
            let hostingController = UIHostingController(rootView: adDetailView)
            navigationController?.pushViewController(hostingController, animated: true)
        }
    }
    
    // MARK: - UICollectionView Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: 80, height: 100)
        } else {
            // Adapt UI to be presentable on Iphone and Ipad
            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            let itemsPerRow: CGFloat = isPad ? 3 : 2
            let spacing: CGFloat = 10
            let totalSpacing = spacing * (itemsPerRow + 1)
            let availableWidth = view.frame.width - totalSpacing
            let itemWidth = availableWidth / itemsPerRow
            let itemHeight = isPad ? itemWidth * 1.1 : itemWidth * 1.3

            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    // MARK: - Cell Configuration
    
    private func configureCategoryCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = viewModel.categories[indexPath.row]
        cell.configure(with: category)
        return cell
    }
    
    private func configureAdCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCollectionViewCell.identifier, for: indexPath) as? AdCollectionViewCell else {
            return UICollectionViewCell()
        }
        let ad = viewModel.filteredAds[indexPath.row]
        let categoryName = viewModel.categories.first(where: { $0.id == ad.categoryId })?.name
        cell.configure(with: ad, categoryName: categoryName ?? "")
        return cell
    }
}
