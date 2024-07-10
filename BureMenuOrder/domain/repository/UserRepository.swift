//
//  UserRepository.swift
//  BureMenuOrder
//
//  Created by KsArT on 05.07.2024.
//

import Foundation

protocol UserRepository {
    func getUsers(completion: @escaping (Result<[UserData], Error>) -> Void)

    func getUser(by id: Int, completion: @escaping (Result<UserData?, Error>) -> Void)

    func saveUsers(_ users: [UserData], completion: @escaping (Result<Void, Error>) -> Void)
}
