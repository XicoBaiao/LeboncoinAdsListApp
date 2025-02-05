//
//  CategoryCollectionViewCell.swift
//  LeboncoinListOfAdsApp
//
//  Created by Francisco Baião on 05/02/2025.
//

import UIKit

enum CategoryIconMapper {
    static func imageName(for categoryName: String) -> String {
        switch categoryName {
        case "Tous les produits": return "category_all_products"
        case "Véhicule": return "category_vehicle"
        case "Mode": return "category_fashion"
        case "Bricolage": return "category_tools"
        case "Maison": return "category_home"
        case "Loisirs": return "category_leisure"
        case "Immobilier": return "category_real_estate"
        case "Livres/CD/DVD": return "category_books"
        case "Multimédia": return "category_multimedia"
        case "Service": return "category_services"
        case "Animaux": return "category_pets"
        case "Enfants": return "category_kids"
        default: return "image_placeholder"
        }
    }
}

class CategoryCollectionViewCell: UICollectionViewCell {

    static let identifier = "CategoryCollectionViewCell"

    private let imageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.masksToBounds = true
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .white
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
            imageContainerView.widthAnchor.constraint(equalToConstant: 70),
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
        imageView.image = UIImage(named: CategoryIconMapper.imageName(for: category.name)) ?? UIImage(named: "image_placeholder")
    }
}
