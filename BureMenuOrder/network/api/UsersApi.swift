//
//  UsersApi.swift
//  BureMenuOrder
//
//  Created by KsArT on 10.07.2024.
//

import Foundation

final class UsersApi {

    private let session: UsersServer

    init(session: UsersServer) {
        self.session = session
    }

    func performRequest(endpoint: APIEndpoints, completion: @escaping (Result<[UserNetwork], Error>) -> Void) {
        execute {
            do {
                if Int.random(in: 0...100) < 25 {
                    throw URLError(.timedOut)
                }
                var data:[UserNetwork] = []
                switch endpoint {
                    case .getUsers:
                        data = self.session.getUsers()
                    case .getUser(let id):
                        let user = self.session.getUser(id)
                        if let user {
                            data = [user]
                        }
                    case .saveUsers(let users):
                        users.forEach { user in
                            self.session.saveUser(user)
                        }
                }
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func execute(_ block: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3) {
            block()
        }
    }
}
