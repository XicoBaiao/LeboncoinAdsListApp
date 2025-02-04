//
//  LeboncoinListOfAdsAppApp.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 02/02/2025.
//

import SwiftUI

@main
struct LeboncoinListOfAdsAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        ImageCacheManager.shared.clearCacheIfNeeded() // Clear cache if 24h passed
    }

    var body: some Scene {
        WindowGroup {
            UIViewControllerWrapper(viewController: ListAdsViewController())
                .edgesIgnoringSafeArea(.all) // Extend beyond safe areas
                .navigationBarHidden(true)
        }
    }
}
