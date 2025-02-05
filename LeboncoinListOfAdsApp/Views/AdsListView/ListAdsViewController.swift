//
//  ListAdsViewController.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import UIKit
import SwiftUI

// ViewController responsible for displaying categories and ads.
class ListAdsViewController: UIViewController {

    // ViewModel for managing data
    let viewModel = AdsViewModel()

    // UI Components
    var categoryCollectionView: UICollectionView! // Horizontal category scroll
    var collectionView: UICollectionView! // Grid of ads
    var emptyStateView: UIView! // Shown when no ads are available
    var activityIndicator: UIActivityIndicatorView! // Loading animation

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCategoryCollectionView()
        setupCollectionView()
        setupEmptyStateView()
        setupActivityIndicator()
        setupBindings()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // Fetches ads and categories from ViewModel
    private func fetchData() {
        viewModel.loadCategories()
        viewModel.loadAds()
    }

    @objc func refreshAds() {
        ImageCacheManager.shared.clearCache()
        viewModel.loadAds()
        collectionView.refreshControl?.endRefreshing()
        updateEmptyStateView()
    }
}
