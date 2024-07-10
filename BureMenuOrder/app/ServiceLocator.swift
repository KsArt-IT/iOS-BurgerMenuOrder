//
//  ServiceLocator.swift
//  BureMenuOrder
//
//  Created by KsArT on 06.07.2024.
//

import Foundation

final class ServiceLocator {
    static let shared = ServiceLocator()

    private var services: [String: Any] = [:]

    private init() {}

    func register<T>(service: T) {
        let key = "\(T.self)"
        services[key] = service
    }

    func resolve<T>() -> T? {
        let key = "\(T.self)"
        return services[key] as? T
    }

}
