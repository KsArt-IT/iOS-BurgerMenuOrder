//
//  UsersApi.swift
//  BureMenuOrder
//
//  Created by KsArT on 05.07.2024.
//

import Foundation

final class NetworkServiceImpl: NetworkService {

    private let usersApi: UsersApi

    init(usersApi: UsersApi) {
        self.usersApi = usersApi
    }

    func fetchData(endpoint: APIEndpoints, completion: @escaping (Result<[UserNetwork], any Error>) -> Void) {
        usersApi.performRequest(endpoint: endpoint, completion: completion)
    }

    func saveData(endpoint: APIEndpoints, completion: @escaping (Result<Void, any Error>) -> Void) {
        usersApi.performRequest(endpoint: endpoint) { result in
            switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
