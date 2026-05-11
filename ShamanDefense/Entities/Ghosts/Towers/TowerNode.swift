//
//  TowerNode.swift
//  ShamanDefense
//

import SpriteKit
import SwiftUI

class TowerNode: GhostNode {
    let stats: TowerStats
    let projectileColor: SKColor

    init(character: CharacterData) {
        guard let stats = character.tower else {
            fatalError("TowerNode requires CharacterData.tower stats (id=\(character.id))")
        }
        self.stats = stats
        self.projectileColor = SKColor(character.tint)
        super.init(displayName: character.name, fillColor: SKColor(character.tint))
        startFiring()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    private func startFiring() {
        let wait = SKAction.wait(forDuration: stats.fireInterval)
        let fire = SKAction.run { [weak self] in self?.tryFire() }
        run(.repeatForever(.sequence([wait, fire])), withKey: "tower.fire")
    }

    private func tryFire() {
        guard let scene else { return }
        var nearest: HumanNode?
        var bestDist = stats.range
        for child in scene.children {
            guard let human = child as? HumanNode, human.hp > 0 else { continue }
            let d = hypot(human.position.x - position.x, human.position.y - position.y)
            if d <= bestDist {
                bestDist = d
                nearest = human
            }
        }
        guard let target = nearest else { return }
        fireProjectile(at: target)
    }

    private func fireProjectile(at target: HumanNode) {
        guard let scene else { return }
        let projectile = SKShapeNode(circleOfRadius: 4)
        projectile.fillColor = projectileColor
        projectile.strokeColor = .clear
        projectile.position = position
        projectile.zPosition = 5
        scene.addChild(projectile)

        let speed = stats.projectileSpeed
        let damageAmount = stats.damage
        let hitRadius: CGFloat = 14
        let maxLife: TimeInterval = 3
        var lastElapsed: CGFloat = 0

        let aoeRadius = stats.aoeRadius
        let projectileColor = self.projectileColor
        let homing = SKAction.customAction(withDuration: maxLife) { [weak target, weak scene] node, elapsed in
            let dt = max(0, elapsed - lastElapsed)
            lastElapsed = elapsed

            guard let target, target.parent != nil, target.hp > 0 else {
                node.removeAllActions()
                node.removeFromParent()
                return
            }

            let dx = target.position.x - node.position.x
            let dy = target.position.y - node.position.y
            let dist = hypot(dx, dy)

            if dist <= hitRadius {
                if let aoeRadius, let scene {
                    TowerNode.applyAoEDamage(at: node.position, radius: aoeRadius, amount: damageAmount, in: scene, color: projectileColor)
                } else {
                    target.takeDamage(damageAmount)
                }
                node.removeAllActions()
                node.removeFromParent()
                return
            }

            let step = speed * dt
            if step >= dist {
                node.position = target.position
            } else {
                node.position = CGPoint(
                    x: node.position.x + dx / dist * step,
                    y: node.position.y + dy / dist * step
                )
            }
        }
        projectile.run(.sequence([homing, .removeFromParent()]))
    }

    private static func applyAoEDamage(at point: CGPoint,
                                       radius: CGFloat,
                                       amount: CGFloat,
                                       in scene: SKScene,
                                       color: SKColor) {
        let flash = SKShapeNode(circleOfRadius: radius)
        flash.position = point
        flash.fillColor = color.withAlphaComponent(0.35)
        flash.strokeColor = color
        flash.lineWidth = 2
        flash.zPosition = 4
        scene.addChild(flash)
        flash.run(.sequence([
            .group([.fadeOut(withDuration: 0.25), .scale(to: 1.2, duration: 0.25)]),
            .removeFromParent()
        ]))

        for child in scene.children {
            guard let human = child as? HumanNode, human.hp > 0 else { continue }
            let dx = human.position.x - point.x
            let dy = human.position.y - point.y
            if hypot(dx, dy) <= radius {
                human.takeDamage(amount)
            }
        }
    }
}
