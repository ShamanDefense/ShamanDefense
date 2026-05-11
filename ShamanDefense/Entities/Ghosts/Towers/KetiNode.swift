//
//  KetiNode.swift
//  ShamanDefense
//

import SpriteKit

final class KetiNode: TowerNode {
    init() { super.init(character: GameCollection.character(for: .keti)) }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
}
