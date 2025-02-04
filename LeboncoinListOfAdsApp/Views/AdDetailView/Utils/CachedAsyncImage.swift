//
//  CachedAsyncImage.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import SwiftUI

struct CachedAsyncImage: View {
    let urlString: String?
    let placeholder: Image

    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
                    .resizable()
                    .scaledToFill()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }

    private func loadImage() {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return // URL is invalid, show placeholder
        }

        // Check cache first
        if let cachedImage = ImageCacheManager.shared.getImage(for: url) {
            self.image = cachedImage
            return
        }

        // Otherwise, fetch image
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let fetchedImage = UIImage(data: data), error == nil else {
                return // If there's an error, just keep the placeholder
            }

            // Cache the downloaded image
            ImageCacheManager.shared.cacheImage(fetchedImage, for: url)

            DispatchQueue.main.async {
                self.image = fetchedImage
            }
        }.resume()
    }
}

