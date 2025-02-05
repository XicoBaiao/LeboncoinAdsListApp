//
//  AdDetailView.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import SwiftUI

struct AdDetailView: View {
    let ad: Ad
    let categoryName: String
    @Environment(\.presentationMode) var presentationMode // Handles dismiss

    @State private var isImageFullScreen = false // Controls full-screen state

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(spacing: 0) {
                    AdImageView(imageURL: ad.imagesUrl.thumb, isFullScreen: $isImageFullScreen)

                    AdInfoSection(ad: ad, categoryName: categoryName)
                        .padding(20)
                        .background(
                            Color.white
                                .clipShape(
                                    .rect(
                                        topLeadingRadius: 20,
                                        bottomLeadingRadius: 0,
                                        bottomTrailingRadius: 0,
                                        topTrailingRadius: 20
                                    )
                                )
                        )
                        .offset(y: -30)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .scrollIndicators(.hidden)

            CloseButton {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .fullScreenCover(isPresented: $isImageFullScreen) {
            FullScreenImageView(imageURL: ad.imagesUrl.thumb ?? "")
        }
    }
}

// MARK: - Ad Image View
struct AdImageView: View {
    let imageURL: String?
    @Binding var isFullScreen: Bool

    var body: some View {
        CachedAsyncImage(urlString: imageURL, placeholder: Image("image_placeholder"))
            .frame(maxWidth: .infinity, minHeight: 300)
            .clipped()
            .onTapGesture {
                isFullScreen.toggle()
            }
    }
}

// MARK: - Ad Information Section
struct AdInfoSection: View {
    let ad: Ad
    let categoryName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(ad.creationDate.formatDate())
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Text(categoryName)
                    .font(.headline)
                    .foregroundColor(.gray)
            }

            Text(ad.title)
                .font(.title)
                .foregroundColor(.primary)

            HStack {
                Text("\(ad.price, specifier: "%.2f") €")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)

                if ad.isUrgent {
                    UrgentBadge()
                }
            }

            if let siret = ad.siret, !siret.isEmpty {
                SiretInfo(siret: siret)
            }

            Text("Description")
                .font(.headline)
                .bold()

            Text(ad.adDescription)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Urgent Badge
struct UrgentBadge: View {
    var body: some View {
        Text("URGENT")
            .font(.footnote)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.red)
            .cornerRadius(8)
    }
}

// MARK: - SIRET Info
struct SiretInfo: View {
    let siret: String

    var body: some View {
        HStack {
            Text("SIRET:")
                .font(.headline)
                .bold()

            Text(siret)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.top, 10)
    }
}

// MARK: - Close Button
struct CloseButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.3))
                .clipShape(Circle())
        }
        .padding(.top, 8)
        .padding(.leading, 8)
    }
}
