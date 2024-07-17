//
//  DetailViewController.swift
//  BureMenuOrder
//
//  Created by KsArT on 13.07.2024.
//

import UIKit

class DetailViewController: UIViewController {

    private var contact: UserData?

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let nameBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.65)
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = R.Constant.CornerRadius.small
        view.clipsToBounds = true
        return view
    }()
    private let photo: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor

        view.layer.cornerRadius = R.Constant.CornerRadius.medium
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        return view
    }()
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
//        view.spacing = 8
        return view
    }()
    private let ordersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let depositeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }

    public func configure(_ contact: UserData) {
        self.contact = contact
        setColors()
    }

    private func setColors() {
        guard let contact else { return }

        let color = contact.typeContacts.getColor()
        nameLabel.textColor = color
        nameBackView.layer.borderColor = color.cgColor
        photo.layer.borderColor = color.cgColor
    }

    private func setupViews() {
        guard let contact else { return }

        nameLabel.text = contact.name
        photo.image = UIImage(named: contact.photo)
        ordersLabel.text = "Сделано заказов, всего: \(contact.orderAmount)"
        depositeLabel.text = "Сумма депозита, всего: \(contact.deposite)"

        view.addSubview(photo)
        view.addSubview(nameBackView)
        view.addSubview(nameLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(ordersLabel)
        stackView.addArrangedSubview(depositeLabel)
    }

    private func setupConstraints() {
        photo.translatesAutoresizingMaskIntoConstraints = false
        nameBackView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -R.Constant.small),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: R.Constant.small),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -R.Constant.small),
            stackView.heightAnchor.constraint(lessThanOrEqualToConstant: R.Constant.big),

            photo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: R.Constant.small),
            photo.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -R.Constant.small),

            photo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: R.Constant.small),
            photo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -R.Constant.small),

            nameLabel.topAnchor.constraint(equalTo: photo.topAnchor, constant: R.Constant.small),
            nameLabel.leadingAnchor.constraint(equalTo: photo.leadingAnchor, constant: R.Constant.large),

            nameBackView.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -R.Constant.minimal),
            nameBackView.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: R.Constant.minimal),
            nameBackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -R.Constant.medium),
            nameBackView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: R.Constant.medium),
        ])
    }
}
