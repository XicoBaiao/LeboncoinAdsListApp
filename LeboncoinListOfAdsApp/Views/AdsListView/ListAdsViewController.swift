//
//  ListAdsViewController.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import UIKit
import SwiftUI

class ListAdsViewController: UIViewController {

    // MARK: - Properties
    private let viewModel = AdsViewModel()
    private var collectionView: UICollectionView!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
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

    // MARK: - Setup Methods
    private func setupView() {
        title = "Classified Ads"
    }

    private func setupBindings() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width - 30) / 2, height: 250)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .gray.withAlphaComponent(0.2)
        collectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: AdCollectionViewCell.identifier)

        // Add UIRefreshControl for pull-to-refresh
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshAds), for: .valueChanged)

        view.addSubview(collectionView)
    }

    // MARK: - Data Fetching
    private func fetchData() {
        viewModel.loadAds()
        viewModel.loadCategories()
    }

    @objc private func refreshAds() {
        ImageCacheManager.shared.clearCache()
        viewModel.loadAds()
        collectionView.refreshControl?.endRefreshing()
    }
}

// MARK: - UICollectionView Delegate & Data Source
extension ListAdsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.ads.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCollectionViewCell.identifier, for: indexPath) as? AdCollectionViewCell else {
            return UICollectionViewCell()
        }
        let ad = viewModel.ads[indexPath.row]
        let categoryName = viewModel.categories.first(where: { $0.id == ad.categoryId })?.name
        cell.configure(with: ad, categoryName: categoryName ?? "")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ad = viewModel.ads[indexPath.row]
        let adDetailView = AdDetailView(ad: ad, categoryName: viewModel.categories.first(where: { $0.id == ad.categoryId })?.name ?? "")
        let hostingController = UIHostingController(rootView: adDetailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

