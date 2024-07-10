//
//  NetworkService.swift
//  BureMenuOrder
//
//  Created by KsArT on 10.07.2024.
//

import Foundation

protocol NetworkService {
    func fetchData(endpoint: APIEndpoints, completion: @escaping (Result<[UserNetwork], Error>) -> Void)
    func saveData(endpoint: APIEndpoints, completion: @escaping (Result<Void, Error>) -> Void)
}
