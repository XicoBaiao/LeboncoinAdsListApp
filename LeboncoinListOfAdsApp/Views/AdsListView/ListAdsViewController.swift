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
    private var emptyStateView: UIView!
    private var activityIndicator: UIActivityIndicatorView!

    // MARK: - Lifecycle Methods
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

    // MARK: - Setup Methods
    private func setupView() {
        title = "Classified Ads"
    }

    private func setupBindings() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.updateEmptyStateView()
            }
        }

        viewModel.showErrorMessage = { [weak self] message in
            guard let self = self, let message = message else { return }
            DispatchQueue.main.async {
                self.showErrorAlert(message: message)
                self.updateEmptyStateView()
            }
        }

        viewModel.updateLoadingState = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
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

    private func setupEmptyStateView() {
        emptyStateView = UIView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)

        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .gray

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No ads available. Tap to retry."
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        emptyStateView.addSubview(imageView)
        emptyStateView.addSubview(label)

        // Expand emptyStateView to full screen for tap detection
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Center the content (icon + text) inside emptyStateView
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -20), // Slightly above center
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),

            label.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20)
        ])

        // Enable tap gesture for retry
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(refreshAds))
        emptyStateView.addGestureRecognizer(tapGesture)
        emptyStateView.isUserInteractionEnabled = true
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
        updateEmptyStateView()
    }

    // MARK: - Show/Hide Empty State View
    private func updateEmptyStateView() {
        let isEmpty = viewModel.ads.isEmpty
        emptyStateView.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
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

