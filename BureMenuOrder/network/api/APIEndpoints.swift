//
//  APIEndpoints.swift
//  BureMenuOrder
//
//  Created by KsArT on 10.07.2024.
//

import Foundation

enum APIEndpoints {
    case getUsers
    case getUser(id: Int)
    case saveUsers([UserNetwork])
}
