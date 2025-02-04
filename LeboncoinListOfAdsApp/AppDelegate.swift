//
//  AppDelegate.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("⚠️ Memory warning received, clearing image cache...")
        ImageCacheManager.shared.clearCache()
    }
}
