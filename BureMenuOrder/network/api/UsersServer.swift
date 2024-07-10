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
    private let depositeForNewUser = 1000.0
    private let letters = "abcdefghijklmnopqrstuvwxyz"
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
                    orderAmount: 0,
                    deposite: depositeForNewUser
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
            let user = UserNetwork(
                id: id,
                name: getRandomName(Int.random(in: 4...10)),
                photo: getPhoto(id),
                orderAmount: 1000,
                deposite: 100
            )
            users.append(user)
            lastId = id
        }
    }

    private func getRandomName(_ size: Int) -> String {
        var name: String = getRandomChar().uppercased()
        for _ in 2...size {
            name.append(getRandomChar())
        }
        return name
    }

    private func getRandomChar() -> Character {
        letters[letters.index(letters.startIndex, offsetBy: Int.random(in: 0..<letters.count))]
    }

    private func getPhoto(_ index: Int) -> String {
        var i = index % photoCount
        if i == 0 {
            i = photoCount
        }
        return String(format: "%03d", i)
    }
}
