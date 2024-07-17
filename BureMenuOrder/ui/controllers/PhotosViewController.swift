//
//  PhotosViewController.swift
//  BureMenuOrder
//
//  Created by KsArT on 17.07.2024.
//

import UIKit

class PhotosViewController: UIViewController {

    private var userRepository: UserRepository?
    private var contacts: [UserData] = []

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // Настройка размера элементов
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // зарегистрируем ячейку
        view.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        return view
    }()
    private let loading: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()

        loadDate()
    }

    private func loadDate() {
        showLoader()
        userRepository = ServiceLocator.shared.resolve()
        userRepository?.getUsers { [weak self] result in
            switch result {
                case .success(let data):
                    // Обработка успешного получения данных
                    print(UserType.allCases.count)
                    self?.contacts = data
                    self?.reloadCollection()
                case .failure(let error):
                    // Обработка ошибки
                    self?.showAlert("Error!", message: error.localizedDescription)
            }
            self?.showLoader(false)
        }
    }

    private func setupViews() {
        view.addSubview(collectionView)
        // последним и самым верхним
        view.addSubview(loading)

        // зарегистрируем делегата
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        loading.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: R.Constant.small),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -R.Constant.small),

            loading.topAnchor.constraint(equalTo: view.topAnchor),
            loading.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loading.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loading.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func showLoader(_ show: Bool = true) {
        if show {
            loading.startAnimating()
        } else {
            loading.stopAnimating()
        }
    }

    private func showDetailController(for contact: UserData) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailControllerSID") as? DetailViewController {
            vc.configure(contact)
            // скрыть tabBarController при переходе на DetailViewController
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < contacts.count else { fatalError("\(PhotoCell.identifier) item=\(indexPath.item) > count=\(contacts.count)") }
        guard let ceil = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { fatalError("\(PhotoCell.identifier) not ceil")}

        ceil.configure(user: contacts[indexPath.item])
        return ceil
    }
    
    func reloadCollection() {
        collectionView.reloadData()
    }

}

extension PhotosViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < contacts.count else { fatalError("\(PhotoCell.identifier) item=\(indexPath.item) > count=\(contacts.count)") }

        showDetailController(for: contacts[indexPath.item])
    }
}
