//
//  Mappers.swift
//  BureMenuOrder
//
//  Created by KsArT on 05.07.2024.
//

import Foundation

extension UserNetwork {
    func mapToData() -> UserData {
        UserData(id: self.id, name: self.name, photo: self.photo, orderAmount: self.orderAmount, deposite: self.deposite)
    }
}
