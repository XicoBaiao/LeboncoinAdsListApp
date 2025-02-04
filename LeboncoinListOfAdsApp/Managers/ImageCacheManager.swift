//
//  ImageCacheManager.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()

    private let cache = NSCache<NSURL, UIImage>()

    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB cache
    }

    func getImage(for url: URL) -> UIImage? {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        } else {
            return nil
        }
    }

    func cacheImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check cache first
        if let cachedImage = getImage(for: url) {
            completion(cachedImage)
            return
        }

        // Otherwise, fetch image asynchronously
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil) // If response is nil, return placeholder
                return
            }

            // Handle 404 error explicitly
            if httpResponse.statusCode == 404 {
                completion(nil) // Return nil to show the placeholder
                return
            }

            // Ensure we have valid image data
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(nil) // Return nil if image loading failed
                return
            }

            // Cache the downloaded image
            self.cacheImage(image, for: url)

            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }

    func clearCache() {
        cache.removeAllObjects()
    }

    func clearCacheIfNeeded() {
        let lastCleared = UserDefaults.standard.double(forKey: "lastCacheClearTime")
        let now = Date().timeIntervalSince1970
        let twentyFourHours: TimeInterval = 24 * 60 * 60

        if now - lastCleared > twentyFourHours {
            clearCache()
            UserDefaults.standard.set(now, forKey: "lastCacheClearTime")
        }
    }
}

