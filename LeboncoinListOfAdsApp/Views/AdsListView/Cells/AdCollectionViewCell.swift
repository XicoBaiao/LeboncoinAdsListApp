//
//  AdCollectionViewCell.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 04/02/2025.
//

import UIKit

class AdCollectionViewCell: UICollectionViewCell {
    static let identifier = "AdCollectionViewCell"

    private var imageURL: URL?

    private let adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()

    // Activity Indicator (Loading Spinner)
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private let urgentBadge: UILabel = {
        let label = UILabel()
        label.text = "URGENT"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .red
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureContentView()

        contentView.addSubview(adImageView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(urgentBadge)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(dateLabel)

        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }

    private func configureConstraints() {
        adImageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        urgentBadge.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            adImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            adImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Center activity indicator inside image view
            activityIndicator.centerXAnchor.constraint(equalTo: adImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: adImageView.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: adImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),

            urgentBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            urgentBadge.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            urgentBadge.widthAnchor.constraint(equalToConstant: 60),
            urgentBadge.heightAnchor.constraint(equalToConstant: 18),

            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            categoryLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -5),

            adImageView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }

    func configure(with ad: Ad, categoryName: String) {
        titleLabel.text = ad.title
        priceLabel.text = "\(ad.price)€"
        urgentBadge.isHidden = !ad.isUrgent
        categoryLabel.text = categoryName
        dateLabel.text = ad.creationDate.formatDate()

        // Show loading indicator while fetching the image
        activityIndicator.startAnimating()
        // Ensure correct image appears (Prevent flickering)
        adImageView.image = UIImage(named: "image_placeholder")

        if let imageUrlString = ad.imagesUrl.thumb, let url = URL(string: imageUrlString) {
            self.imageURL = url
            adImageView.tag = ad.id

            ImageCacheManager.shared.loadImage(from: url) { [weak self] image in
                guard let self = self, self.imageURL == url else { return }

                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.adImageView.image = image ?? UIImage(named: "image_placeholder")
                }
            }
        }
    }
}
