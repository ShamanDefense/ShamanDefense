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

enum GhostMetrics {
    static let diameter: CGFloat = 30
}

enum GhostID: String, CaseIterable, Hashable {
    case keti, poci, gugun, yayang, yuyul
}

struct CharacterData: Identifiable, Hashable {
    let id: GhostID
    let name: String
    let cost: Int
    let description: String
    let symbol: String
    let tint: Color
    let kind: EntityKind
}

struct GameCollection {
    static let allCharacters: [CharacterData] = [
        CharacterData(id: .keti,   name: "Keti",   cost: 3, description: "Keti attacks with piercing sound waves that disable humans.", symbol: "flame.fill",    tint: .orange, kind: .tower),
        CharacterData(id: .poci,   name: "Poci",   cost: 4, description: "Poci attacks at close range by charging forward and headbutting enemies.", symbol: "drop.fill",     tint: .cyan,   kind: .tower),
        CharacterData(id: .gugun,  name: "Gugun",  cost: 5, description: "Gugun's massive power can wipe out up to 5 humans at once.", symbol: "bolt.fill",     tint: .yellow, kind: .tower),
        CharacterData(id: .yayang, name: "Yayang", cost: 2, description: "Yayang can freeze humans for 5 seconds by shocking them with its sudden presence.", symbol: "hare.fill",     tint: .pink,   kind: .trap),
        CharacterData(id: .yuyul,  name: "Yuyul",  cost: 2, description: "Yuyul creates an area that slows human movement for 5 seconds.", symbol: "tortoise.fill", tint: .purple, kind: .trap)
    ]
}
