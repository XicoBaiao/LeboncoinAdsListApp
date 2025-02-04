//
//  ListAdsView+Bindings.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import UIKit

extension ListAdsViewController {

    // Binds the ViewModel's updates to the UI
    func setupBindings() {
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
}
