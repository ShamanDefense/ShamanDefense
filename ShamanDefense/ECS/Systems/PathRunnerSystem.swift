//
//  PathRunnerSystem.swift
//  ShamanDefense
//

import GameplayKit
import CoreGraphics

final class PathRunnerSystem: ComponentSystem<PathRunnerComponent> {
    override func update(deltaTime: TimeInterval) {
        for runner in components {
            tick(runner, dt: deltaTime)
        }
    }

    private func tick(_ runner: PathRunnerComponent, dt: TimeInterval) {
        guard runner.active, !runner.completed,
              let entity = runner.entity as? GameEntity,
              let sprite = entity.component(ofType: SpriteComponent.self),
              runner.segmentIndex + 1 < runner.waypoints.count else { return }

        var pos = sprite.position
        var step = runner.speed * CGFloat(dt)

        while step > 0 && runner.segmentIndex + 1 < runner.waypoints.count {
            let next = runner.waypoints[runner.segmentIndex + 1]
            let dx = next.x - pos.x
            let dy = next.y - pos.y
            let dist = hypot(dx, dy)
            if step >= dist {
                pos = next
                step -= dist
                runner.segmentIndex += 1
            } else {
                pos.x += dx / dist * step
                pos.y += dy / dist * step
                step = 0
            }
        }
        sprite.position = pos

        if runner.segmentIndex + 1 >= runner.waypoints.count {
            runner.completed = true
            runner.onComplete?()
        }
    }
}
