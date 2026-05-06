//
//  CharacterData.swift
//  ShamanDefense
//
//  Created by Mohammad Rizaldy Ramadhan on 06/05/26.
//

import SwiftUI

enum EntityKind {
    case tower
    case trap
}

struct CharacterData: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let cost: Int
    let symbol: String
    let tint: Color
    let kind: EntityKind
}

struct GameCollection {
    static let allCharacters: [CharacterData] = [
        CharacterData(name: "Keti",   cost: 3, symbol: "flame.fill",    tint: .orange, kind: .tower),
        CharacterData(name: "Poci",   cost: 4, symbol: "drop.fill",     tint: .cyan,   kind: .tower),
        CharacterData(name: "Gugun",  cost: 5, symbol: "bolt.fill",     tint: .yellow, kind: .tower),
        CharacterData(name: "Yayang", cost: 2, symbol: "hare.fill",     tint: .pink,   kind: .trap),
        CharacterData(name: "Yuyul",  cost: 2, symbol: "tortoise.fill", tint: .purple, kind: .trap)
    ]
}
