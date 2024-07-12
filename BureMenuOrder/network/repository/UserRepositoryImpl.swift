//
//  UserRepositoryImpl.swift
//  BureMenuOrder
//
//  Created by KsArT on 05.07.2024.
//

import Foundation

final class UserRepositoryImpl: UserRepository {

    private let service: NetworkService

    init(service: NetworkService) {
        self.service = service
    }

    func getUsers(completion: @escaping (Result<[UserData], Error>) -> Void) {
        service.fetchData(endpoint: .getUsers) { result in
            switch result {
                case .success(let data):
                    let users = data.map { $0.mapToData() }
                    self.executeToMain {
                        completion(.success(users))
                    }

                case .failure(let error):
                    self.executeToMain {
                        completion(.failure(error))
                    }
            }
        }
    }

    func getUser(by id: Int, completion: @escaping (Result<UserData?, Error>) -> Void) {
        service.fetchData(endpoint: .getUser(id: id)) { result in
            switch result {
                case .success(let data):
                    let user = data.first?.mapToData()
                    self.executeToMain {
                        completion(.success(user))
                    }
                case .failure(let error):
                    self.executeToMain {
                        completion(.failure(error))
                    }
            }
        }
    }

    func saveUsers(_ users: [UserData], completion: @escaping (Result<Void, Error>) -> Void) {
        service.saveData(endpoint: .saveUsers(users.map { $0.mapToNetwork() })) { result in
            switch result {
                case .success(_):
                    self.executeToMain {
                        completion(.success(()))
                    }
                case .failure(let error):
                    self.executeToMain {
                        completion(.failure(error))
                    }
            }
        }
    }

    private func executeToMain(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
}
