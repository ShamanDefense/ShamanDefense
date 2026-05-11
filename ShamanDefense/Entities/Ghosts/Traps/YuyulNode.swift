//
//  YuyulNode.swift
//  ShamanDefense
//

import SpriteKit
import SwiftUI

final class YuyulNode: TrapNode {
    private let runSpeed: CGFloat = 220
    private let slowRadius: CGFloat = 60
    private let slowFactor: CGFloat = 0.4
    private let slowDuration: TimeInterval = 2.0

    init() {
        let c = GameCollection.character(for: .yuyul)
        super.init(displayName: c.name, fillColor: SKColor(c.tint))
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func trigger(by human: HumanNode) {
        guard !pathWaypoints.isEmpty else { return }
        let path = remainingPath(from: position, waypoints: pathWaypoints)

        let scan = SKAction.run { [weak self] in self?.slowNearby() }
        let scanLoop = SKAction.repeatForever(.sequence([.wait(forDuration: 0.1), scan]))
        run(scanLoop, withKey: "yuyul.scan")

        let follow = SKAction.follow(path, asOffset: false, orientToPath: true, speed: runSpeed)
        run(.sequence([follow, .removeFromParent()]))
    }

    private func slowNearby() {
        guard let scene else { return }
        for child in scene.children {
            guard let h = child as? HumanNode, h.hp > 0 else { continue }
            if hypot(h.position.x - position.x, h.position.y - position.y) <= slowRadius {
                h.applySlow(factor: slowFactor, duration: slowDuration)
            }
        }
    }

    private func remainingPath(from pos: CGPoint, waypoints: [CGPoint]) -> CGPath {
        let path = CGMutablePath()
        path.move(to: pos)
        var nearest = 0
        var best = CGFloat.greatestFiniteMagnitude
        for i in 0..<waypoints.count - 1 {
            let d = pointToSegment(pos, waypoints[i], waypoints[i + 1])
            if d < best { best = d; nearest = i }
        }
        for i in stride(from: nearest, through: 0, by: -1) {
            path.addLine(to: waypoints[i])
        }
        return path
    }

    private func pointToSegment(_ p: CGPoint, _ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let dx = b.x - a.x
        let dy = b.y - a.y
        let lenSq = dx * dx + dy * dy
        guard lenSq > 0 else { return hypot(p.x - a.x, p.y - a.y) }
        var t = ((p.x - a.x) * dx + (p.y - a.y) * dy) / lenSq
        t = max(0, min(1, t))
        return hypot(p.x - (a.x + t * dx), p.y - (a.y + t * dy))
    }
}
