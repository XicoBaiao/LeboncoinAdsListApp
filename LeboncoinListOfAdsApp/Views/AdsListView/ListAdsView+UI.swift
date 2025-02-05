//
//  ListAdsView+UI.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import UIKit

extension ListAdsViewController {

    // Sets up the navigation title
    func setupView() {
        title = "Classified Ads"
    }

    // Configures the horizontal category collection view
    func setupCategoryCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.backgroundColor = .clear
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)

        view.addSubview(categoryCollectionView)

        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }

    // Configures the main collection view (grid for ads)
    func setupAdsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width - 30) / 2, height: 250)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        adsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        adsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        adsCollectionView.delegate = self
        adsCollectionView.dataSource = self
        adsCollectionView.showsVerticalScrollIndicator = false
        adsCollectionView.backgroundColor = .gray.withAlphaComponent(0.2)
        adsCollectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: AdCollectionViewCell.identifier)

        // Enables pull-to-refresh feature
        adsCollectionView.refreshControl = UIRefreshControl()
        adsCollectionView.refreshControl?.addTarget(self, action: #selector(refreshAds), for: .valueChanged)

        view.addSubview(adsCollectionView)

        NSLayoutConstraint.activate([
            adsCollectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 10),
            adsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // Reusable empty state view for both cases: No ads at all OR No ads for category
    func setupEmptyStateView() {
        emptyStateView = UIView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)

        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .gray

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        emptyStateView.addSubview(imageView)
        emptyStateView.addSubview(label)

        // Expands emptyStateView to detect taps
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Centers the image and label in the emptyStateView
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),

            label.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20)
        ])
    }

    // Updates the empty state view dynamically
    func updateEmptyStateView() {
        let noAds = viewModel.allAds.isEmpty
        let noAdsForCategory = viewModel.filteredAds.isEmpty

        emptyStateView.isHidden = !(noAds || noAdsForCategory)
        adsCollectionView.isHidden = noAdsForCategory

        if noAds {
            showEmptyStateMessage("No ads available. Tap to retry.")
            addTapGestureToEmptyState()
        } else if noAdsForCategory {
            showEmptyStateMessage("No ads for this category. Please choose a different one.")
            removeTapGestureFromEmptyState()
        }
    }

    // Updates the message displayed in the empty state view
    private func showEmptyStateMessage(_ message: String) {
        if let label = emptyStateView.subviews.compactMap({ $0 as? UILabel }).first {
            label.text = message
        }
    }

    // Adds tap gesture ONLY when no ads exist at all
    private func addTapGestureToEmptyState() {
        removeTapGestureFromEmptyState() // Ensure we remove any previous gestures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(fetchData))
        emptyStateView.addGestureRecognizer(tapGesture)
        emptyStateView.isUserInteractionEnabled = true
    }

    // Removes tap gesture when no ads exist for a category (prevents unnecessary API calls)
    private func removeTapGestureFromEmptyState() {
        emptyStateView.gestureRecognizers?.forEach { emptyStateView.removeGestureRecognizer($0) }
        emptyStateView.isUserInteractionEnabled = false
    }

    // Configures and positions the activity indicator (loading spinner)
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // Displays an error alert message
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
