//
//  ListAdsView+Bindings.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import UIKit

// Handle all callbacks from viewModel
extension ListAdsViewController {

    func setupBindings() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.adsCollectionView.reloadData()
                self?.updateEmptyStateView()
            }
        }

        viewModel.reloadCategories = { [weak self] in
            DispatchQueue.main.async {
                self?.categoryCollectionView.reloadData()
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
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
        }
    }
}
