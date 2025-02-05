//
//  CategoryCollectionViewCell.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 05/02/2025.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    static let identifier = "CategoryCollectionViewCell"

    private let imageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35 // Slightly larger than imageView
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.darkGray.cgColor // Border color
        view.layer.masksToBounds = true
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .white // Keep white background
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageContainerView.widthAnchor.constraint(equalToConstant: 70), // Slightly larger
            imageContainerView.heightAnchor.constraint(equalToConstant: 70),

            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with category: Category) {
        titleLabel.text = category.name
        imageView.image = UIImage(named: imageName(for: category.name)) ?? UIImage(named: "image_placeholder")
    }

    /// Maps category names to the corresponding image asset names.
    private func imageName(for categoryName: String) -> String {
        let categoryMap: [String: String] = [
            "Tous les produits": "category_all_products",
            "Véhicule": "category_vehicle",
            "Mode": "category_fashion",
            "Bricolage": "category_tools",
            "Maison": "category_home",
            "Loisirs": "category_leisure",
            "Immobilier": "category_real_estate",
            "Livres/CD/DVD": "category_books",
            "Multimédia": "category_multimedia",
            "Service": "category_services",
            "Animaux": "category_pets",
            "Enfants": "category_kids"
        ]

        return categoryMap[categoryName] ?? "image_placeholder"
    }
}
