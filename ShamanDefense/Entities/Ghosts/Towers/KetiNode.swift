//
//  KetiNode.swift
//  ShamanDefense
//
//  Created by Richie Daryl Kwenandar on 06/05/26.
//

import SpriteKit

final class KetiNode: TowerNode {
    init() {
        super.init(
            displayName: "Keti",
            fillColor: .orange,
            range: 220,
            fireInterval: 1.0,
            damage: 1,
            projectileColor: .orange
        )
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
}
