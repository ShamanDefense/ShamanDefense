//
//  YayangNode.swift
//  ShamanDefense
//

import SpriteKit
import SwiftUI

final class YayangNode: TrapNode {
    private let freezeDuration: TimeInterval = 2.0

    init() {
        let c = GameCollection.character(for: .yayang)
        super.init(displayName: c.name, fillColor: SKColor(c.tint))
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func trigger(by human: HumanNode) {
        guard let scene else { return }

        let pulse = SKShapeNode(circleOfRadius: 40)
        pulse.position = position
        pulse.fillColor = SKColor.cyan.withAlphaComponent(0.25)
        pulse.strokeColor = .cyan
        pulse.lineWidth = 2
        pulse.zPosition = 4
        scene.addChild(pulse)
        pulse.run(.sequence([
            .group([.scale(to: 12, duration: 0.5), .fadeOut(withDuration: 0.5)]),
            .removeFromParent()
        ]))

        for child in scene.children {
            guard let h = child as? HumanNode, h.hp > 0 else { continue }
            h.applyFreeze(duration: freezeDuration)
        }

        run(.sequence([.fadeOut(withDuration: 0.4), .removeFromParent()]))
    }
}
