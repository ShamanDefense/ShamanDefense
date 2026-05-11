//
//  GugunNode.swift
//  ShamanDefense
//

import SpriteKit

final class GugunNode: TowerNode {
    init() { super.init(character: GameCollection.character(for: .gugun)) }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
}
