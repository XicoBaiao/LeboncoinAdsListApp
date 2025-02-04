//
//  ListAdsViewController.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import UIKit
import SwiftUI

// ViewController responsible for displaying a list of ads.
class ListAdsViewController: UIViewController {

    // ViewModel for handling business logic
    let viewModel = AdsViewModel()

    // UI Components
    var collectionView: UICollectionView!  // Displays the list of ads
    var emptyStateView: UIView!  // View shown when no ads are available
    var activityIndicator: UIActivityIndicatorView!  // Shows a loading animation

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        viewModel.loadAds()
        viewModel.loadCategories()
    }

    // Refreshes ads and clears cache when user pulls to refresh
    @objc func refreshAds() {
        ImageCacheManager.shared.clearCache()
        viewModel.loadAds()
        collectionView.refreshControl?.endRefreshing()
        updateEmptyStateView()
    }
}
