//
//  TowerNode.swift
//  ShamanDefense
//

import SpriteKit

class TowerNode: GhostNode {
    let range: CGFloat
    let fireInterval: TimeInterval
    let damage: CGFloat
    let projectileColor: SKColor
    let projectileSpeed: CGFloat

    init(displayName: String,
         fillColor: SKColor,
         range: CGFloat,
         fireInterval: TimeInterval,
         damage: CGFloat,
         projectileColor: SKColor,
         projectileSpeed: CGFloat = 420) {
        self.range = range
        self.fireInterval = fireInterval
        self.damage = damage
        self.projectileColor = projectileColor
        self.projectileSpeed = projectileSpeed
        super.init(displayName: displayName, fillColor: fillColor)
        startFiring()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    private func startFiring() {
        let wait = SKAction.wait(forDuration: fireInterval)
        let fire = SKAction.run { [weak self] in self?.tryFire() }
        run(.repeatForever(.sequence([wait, fire])), withKey: "tower.fire")
    }

    private func tryFire() {
        guard let scene else { return }
        var nearest: HumanNode?
        var bestDist = range
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

        let speed = projectileSpeed
        let damageAmount = damage
        let hitRadius: CGFloat = 14
        let maxLife: TimeInterval = 3
        var lastElapsed: CGFloat = 0

        let homing = SKAction.customAction(withDuration: maxLife) { [weak target] node, elapsed in
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
                target.takeDamage(damageAmount)
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
}
