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

        view.layer.cornerRadius = R.Constant.CornerRadius.medium
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

        nameBackView.backgroundColor = .white.withAlphaComponent(0.75)
        nameBackView.layer.cornerRadius = R.Constant.CornerRadius.small
        nameBackView.layer.borderWidth = 1
        nameBackView.layer.borderColor = UIColor.red.cgColor
        nameBackView.clipsToBounds = true
    }

    private func setupConstraint() {
        photo.translatesAutoresizingMaskIntoConstraints = false
        nameBackView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: R.Constant.small),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -R.Constant.small),
            photo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            // максимальная требуемая 200
            photo.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            // 80% от ширины
            photo.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            // соотношение сторон 1:1
            photo.heightAnchor.constraint(equalTo: photo.widthAnchor, multiplier: 1.0),

            nameLabel.bottomAnchor.constraint(equalTo: photo.bottomAnchor, constant: -R.Constant.medium),
            nameLabel.trailingAnchor.constraint(equalTo: photo.trailingAnchor, constant: -R.Constant.big),

            nameBackView.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -R.Constant.minimal),
            nameBackView.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: R.Constant.minimal),
            nameBackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -R.Constant.large),
            nameBackView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: R.Constant.large),

        ])
    }

    func configure(user: UserData) {
        photo.image = UIImage(named: user.photo)
        nameLabel.text = user.name
        setColors(user: user)
    }

    private func setColors(user: UserData) {
        let color = user.typeContacts.getColor()
        nameLabel.textColor = color
        nameBackView.layer.borderColor = color.cgColor
        photo.layer.borderColor = color.cgColor
    }

}
