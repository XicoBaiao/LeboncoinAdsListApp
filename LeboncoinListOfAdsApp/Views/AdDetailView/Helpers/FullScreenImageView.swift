//
//  FullScreenImageView.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import SwiftUI

struct FullScreenImageView: View {
    let imageURL: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            CachedAsyncImage(urlString: imageURL, placeholder: Image("image_placeholder"))
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)


            // Close Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
}
