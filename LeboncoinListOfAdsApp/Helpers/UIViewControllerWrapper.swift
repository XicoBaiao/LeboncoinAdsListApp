//
//  UIViewControllerWrapper.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import UIKit
import SwiftUI

// Wrapper to use a UIViewController inside a SwiftUI View
struct UIViewControllerWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        // Embed the view controller inside a navigation controller
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
