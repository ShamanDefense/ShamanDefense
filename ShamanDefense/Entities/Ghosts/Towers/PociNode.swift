//
//  PociNode.swift
//  ShamanDefense
//
//  Created by Richie Daryl Kwenandar on 06/05/26.
//

import SpriteKit

final class PociNode: TowerNode {
    init() {
        super.init(
            displayName: "Poci",
            fillColor: .cyan,
            range: 60,
            fireInterval: 0.4,
            damage: 1,
            projectileColor: .cyan,
            projectileSpeed: 600
        )
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
}
