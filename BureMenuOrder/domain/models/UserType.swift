//
//  UserType.swift
//  BureMenuOrder
//
//  Created by KsArT on 12.07.2024.
//

import Foundation

enum UserType: Double, CaseIterable {
    case vipClient = 10000.0
    static let vipClientTitle = "VIP client"

    case newClient = 1000.0
    static let newClientTitle = "New client"

    case goodClient = 5000.0
    static let goodClientTitle = "Good Client"

    case client = 100.0
    static let clientTitle = "Client"

    case debtor = -1000
    static let debtorTitle = "Debtor"

    static func getType(_ sum: Double) -> UserType {
        switch sum {
            case -10000...0: debtor
            case newClient.rawValue: newClient
            case goodClient.rawValue..<vipClient.rawValue: goodClient
            case vipClient.rawValue...: vipClient
            default: client
        }
    }

    static func getClientMoney() -> (deposite: Double, orderAmount: Double) {
        switch Int.random(in: 0...100) {
            case 0..<20: (UserType.newClient.rawValue, 0)
            case 20..<40: (UserType.client.rawValue,
                           Int.random(in: 0..<UserType.goodClient.rawValue.toInt()).toDouble())
            case 40..<80: (UserType.goodClient.rawValue,
                           Int.random(in: UserType.goodClient.rawValue.toInt()..<UserType.vipClient.rawValue.toInt()).toDouble())
            case 80..<90: (UserType.debtor.rawValue, 0)
            case 90...100: (UserType.vipClient.rawValue,
                            Int.random(in: UserType.vipClient.rawValue.toInt()...UserType.vipClient.rawValue.toInt()*100).toDouble())
            default: (0, 0)
        }
    }

}
