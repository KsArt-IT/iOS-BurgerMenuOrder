//
//  ContactCell.swift
//  BureMenuOrder
//
//  Created by KsArT on 10.07.2024.
//

import UIKit

class ContactCell: UITableViewCell {

    static let identifier = "ContactCell"
    
    let photo: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor

        view.layer.cornerRadius = 25
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }()
    let nameBackView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {
        contentView.addSubview(photo)
        contentView.addSubview(nameBackView)
        contentView.addSubview(nameLabel)

        nameBackView.backgroundColor = .white.withAlphaComponent(0.65)
        nameBackView.layer.cornerRadius = 16
        nameBackView.layer.borderWidth = 1
        nameBackView.layer.borderColor = UIColor.red.cgColor
        nameBackView.clipsToBounds = true
    }

    private func setupConstraint() {
        photo.translatesAutoresizingMaskIntoConstraints = false
        nameBackView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            nameLabel.bottomAnchor.constraint(equalTo: photo.bottomAnchor, constant: -16),
            nameLabel.trailingAnchor.constraint(equalTo: photo.trailingAnchor, constant: -50),

            nameBackView.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -2),
            nameBackView.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            nameBackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -20),
            nameBackView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20),

        ])
    }

    func configure(user: UserData) {
        photo.image = UIImage(named: user.photo)
        nameLabel.text = user.name
    }

}
