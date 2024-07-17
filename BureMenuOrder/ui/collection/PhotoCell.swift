//
//  PhotoCell.swift
//  BureMenuOrder
//
//  Created by KsArT on 17.07.2024.
//

import UIKit

final class PhotoCell: UICollectionViewCell {

    static let identifier = "PhotoCell"

    let photo: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor

        view.layer.cornerRadius = R.Constant.CornerRadius.medium
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {
        contentView.addSubview(photo)
    }

    private func setupConstraint() {
        photo.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: contentView.topAnchor),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    func configure(user: UserData) {
        photo.image = UIImage(named: user.photo)
        setColors(user: user)
    }

    private func setColors(user: UserData) {
        let color = user.typeContacts.getColor()
        photo.layer.borderColor = color.cgColor
    }

}
