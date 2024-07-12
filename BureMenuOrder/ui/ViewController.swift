//
//  ViewController.swift
//  BureMenuOrder
//
//  Created by KsArT on 05.07.2024.
//

import UIKit

class ViewController: UIViewController {

    private var userRepository: UserRepository?
    private var contacts: [[UserData]] = [[]]

    private let tableView: UITableView = .init(frame: .zero, style: .plain)
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
                    self?.contacts = [[]]
                    UserType.allCases.forEach { _ in
                        self?.contacts.append([])
                    }
                    data.forEach { user in
                        let index = UserType.allCases.firstIndex(of: user.type) ?? UserType.allCases.count-1
                        print("\(index) -> \(user.name) -> \(user.photo)")
                        self?.contacts[index].append(user)
                    }
                    self?.reloadTable()
                    self?.showLoader(false)
                case .failure(let error):
                    // Обработка ошибки
                    self?.showAlert("Error!", message: error.localizedDescription)
                    self?.showLoader(false)
            }
        }
    }

    private func setupViews() {
        view.addSubview(tableView)
        // последним и самым верхним
        view.addSubview(loading)

        // зарегистрируем ячейку и делегата
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
        tableView.separatorInset = .init(top: 0, left: 50, bottom: 0, right: 50)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loading.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

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
}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        contacts.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: UserType.vipClientTitle
            case 1: UserType.newClientTitle
            case 2: UserType.goodClientTitle
            case 3: UserType.clientTitle
            case 4: UserType.debtorTitle
            default: ""
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < contacts[indexPath.section].count else { fatalError("\(ContactCell.identifier) row=\(indexPath.row) > count=\(contacts.count)") }
        guard let ceil = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as? ContactCell else { fatalError("\(ContactCell.identifier) not ceil")}

        ceil.configure(user: contacts[indexPath.section][indexPath.row])
        return ceil
    }

    func reloadTable() {
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // кнопка действий с картинкой
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, complited in
            // удалим из списка
            self?.contacts.remove(at: indexPath.row)
            // удалим из таблицы
            tableView.deleteRows(at: [indexPath], with: .automatic)
            // скрыть кнопку после
            complited(true)
        }
        // добавим картинку
        actionDelete.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [actionDelete])
    }
}
