//
//  ViewController.swift
//  BureMenuOrder
//
//  Created by KsArT on 05.07.2024.
//

import UIKit

class ViewController: UIViewController {
    var userRepository: UserRepository?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadDate()
    }


    private func loadDate() {
        userRepository = ServiceLocator.shared.resolve()
        userRepository?.getUsers { result in
            switch result {
                case .success(let data):
                    // Обработка успешного получения данных
                    data.forEach { user in
                        print("\(user.name) -> \(user.photo)")
                    }
                case .failure(let error):
                    // Обработка ошибки
                    print("Error: \(error)")
            }
        }
    }
}

