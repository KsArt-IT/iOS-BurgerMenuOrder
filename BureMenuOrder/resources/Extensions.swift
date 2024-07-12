//
//  Extensions.swift
//  BureMenuOrder
//
//  Created by KsArT on 12.07.2024.
//

import Foundation

extension Double {

    func toInt() -> Int {
        Int(self)
    }
}

extension Int {

    func toDouble() -> Double {
        Double(self)
    }
}

extension String {

    static func randomName() -> String {
        getRandomName(Int.random(in: 4...10))
    }
}

private let letters = "abcdefghijklmnopqrstuvwxyz"
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
