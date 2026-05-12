//
//  HomingComponent.swift
//  ShamanDefense
//

import GameplayKit
import CoreGraphics

final class HomingComponent: GKComponent {
    weak var target: GameEntity?
    let speed: CGFloat
    let hitRadius: CGFloat
    var onImpact: ((CGPoint, GameEntity?) -> Void)?
    var onTargetLost: (() -> Void)?

    init(target: GameEntity, speed: CGFloat, hitRadius: CGFloat) {
        self.target = target
        self.speed = speed
        self.hitRadius = hitRadius
        super.init()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func update(deltaTime seconds: TimeInterval) {
        guard let sprite = entity?.component(ofType: SpriteComponent.self) else { return }

        guard let target,
              let targetSprite = target.component(ofType: SpriteComponent.self),
              targetSprite.node.parent != nil,
              let health = target.component(ofType: HealthComponent.self), health.isAlive else {
            onTargetLost?()
            return
        }

        var pos = sprite.position
        let dx = targetSprite.position.x - pos.x
        let dy = targetSprite.position.y - pos.y
        let dist = hypot(dx, dy)

        if dist <= hitRadius {
            onImpact?(pos, target)
            return
        }

        let step = speed * CGFloat(seconds)
        if step >= dist {
            pos = targetSprite.position
        } else {
            pos.x += dx / dist * step
            pos.y += dy / dist * step
        }
        sprite.position = pos
    }
}
