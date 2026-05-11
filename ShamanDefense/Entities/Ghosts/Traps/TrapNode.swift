//
//  TrapNode.swift
//  ShamanDefense
//

import SpriteKit

class TrapNode: GhostNode {
    var pathWaypoints: [CGPoint] = []
    private(set) var armed = true

    func arm() {
        let wait = SKAction.wait(forDuration: 0.08)
        let check = SKAction.run { [weak self] in self?.checkTrigger() }
        run(.repeatForever(.sequence([wait, check])), withKey: "trap.detect")
    }

    private func checkTrigger() {
        guard armed, let scene else { return }
        let triggerRadius: CGFloat = GhostMetrics.diameter / 2 + 6
        for child in scene.children {
            guard let h = child as? HumanNode, h.hp > 0 else { continue }
            if hypot(h.position.x - position.x, h.position.y - position.y) <= triggerRadius {
                armed = false
                removeAction(forKey: "trap.detect")
                trigger(by: h)
                return
            }
        }
    }

    func trigger(by human: HumanNode) {
        // subclasses override
    }
}
