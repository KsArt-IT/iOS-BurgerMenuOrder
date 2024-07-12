//
//  UsersServer.swift
//  BureMenuOrder
//
//  Created by KsArT on 09.07.2024.
//

import Foundation

final class UsersServer {
    static let shared = UsersServer()

    private var users: [UserNetwork] = []
    private var lastId = 0

    private let photoCount = 50

    private init () {}

    public func saveUser(_ user: UserNetwork) {
        configure()
        if user.id <= 0 {
            lastId += 1
            users.append(
                UserNetwork(
                    id: lastId,
                    name: user.name,
                    photo: user.photo,
                    orderAmount: 0, // еще ничего не покупал
                    deposite: UserType.newClient.rawValue // кредит доверия
                )
            )
        } else {
            users.removeAll(where: { $0.id == user.id })
            users.append(user)
        }
    }

    public func getUsers() -> [UserNetwork] {
        configure()
        return users
    }

    public func getUser(_ id: Int) -> UserNetwork? {
        configure()
        return users.first(where: { $0.id == id } )
    }

    private func configure() {
        guard users.isEmpty else { return }

        (10001...10100).forEach { id in
            let clientMoney = UserType.getClientMoney()
            let user = UserNetwork(
                id: id,
                name: String.randomName(),
                photo: getPhoto(id),
                orderAmount: clientMoney.orderAmount,
                deposite: clientMoney.deposite
            )
            users.append(user)
            lastId = id
        }
    }

    private func getPhoto(_ index: Int) -> String {
        var i = index % photoCount
        if i == 0 {
            i = photoCount
        }
        return String(format: "%03d", i)
    }
}
