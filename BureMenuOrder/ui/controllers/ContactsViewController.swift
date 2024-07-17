//
//  ViewController.swift
//  BureMenuOrder
//
//  Created by KsArT on 05.07.2024.
//

import UIKit

class ContactsViewController: UIViewController {

    private var userRepository: UserRepository?
    private var contacts: [[UserData]] = [[]]

    private let tableView: UITableView = .init(frame: .zero, style: .plain)
    private let loading: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        return view
    }()
    // pull to refresh
    private let refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.attributedTitle = NSAttributedString(string: "Идет обновление...")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        
        showLoader(first: true)
        loadDate()
    }

    private func loadDate() {
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
                        let index = UserType.allCases.firstIndex(of: user.typeContacts) ?? UserType.allCases.count-1
                        print("\(index) -> \(user.name) -> \(user.photo)")
                        self?.contacts[index].append(user)
                    }
                    self?.reloadTable()
                case .failure(let error):
                    // Обработка ошибки
                    self?.showAlert("Error!", message: error.localizedDescription)
            }
            self?.showLoader(show: false)
        }
    }

    private func setupViews() {
        view.addSubview(tableView)
        // последним и самым верхним
        view.addSubview(loading)

        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        tableView.refreshControl = refreshControl

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

    @objc private func handleRefreshControl() {
        showLoader()
        loadDate()
    }

    private func showLoader(show: Bool = true, first: Bool = false) {
        if show {
            if first {
                loading.startAnimating()
            } else {
                refreshControl.beginRefreshing()
            }
        } else {
            loading.stopAnimating()
            refreshControl.endRefreshing()
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

extension ContactsViewController: UITableViewDataSource {

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
        guard indexPath.row < contacts[indexPath.section].count else { fatalError("\(ContactCell.identifier) row=\(indexPath.row) > count=\(contacts[indexPath.section].count)") }
        guard let ceil = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as? ContactCell else { fatalError("\(ContactCell.identifier) not ceil")}

        ceil.configure(user: contacts[indexPath.section][indexPath.row])
        return ceil
    }

    func reloadTable() {
        tableView.reloadData()
    }
}

extension ContactsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDetailController(for: contacts[indexPath.section][indexPath.row])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // кнопка действий с картинкой
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, complited in
            // удалим из списка
            self?.contacts[indexPath.section].remove(at: indexPath.row)
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
