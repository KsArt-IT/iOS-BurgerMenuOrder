//
//  UserData.swift
//  BureMenuOrder
//
//  Created by KsArT on 05.07.2024.
//

import Foundation

struct UserData {
    let id: Int // id в локальной базе
    let name: String // имя пользователя
    let photo: String // фото
    let orderAmount: Double // всего заказано на сумму
    let deposite: Double // сумма депозита или возможность предзаказа
    let type: UserType // тип клиента, новый или вип или простой клиент
}
