//
//  PociNode.swift
//  ShamanDefense
//

import SpriteKit

final class PociNode: TowerNode {
    init() { super.init(character: GameCollection.character(for: .poci)) }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
}
