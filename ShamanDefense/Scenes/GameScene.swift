//
//  GameScene.swift
//  ShamanDefense
//
//  Created by Richie Daryl Kwenandar on 06/05/26.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {

    private let tileSize: CGFloat = 36
    private let minPlacementSpacing: CGFloat = GhostMetrics.diameter
    private var pathManager: PathManager!

    private(set) var registry: EntityRegistry!
    private var lastUpdateTime: TimeInterval = 0
    private var pendingRemovals: [GameEntity] = []

    let humansLayer = SKNode()
    let towersLayer = SKNode()
    let trapsLayer = SKNode()
    let projectilesLayer = SKNode()
    let fxLayer = SKNode()

    private func tooCloseToExisting(_ point: CGPoint) -> Bool {
        for entity in registry.all {
            guard let blocker = entity.component(ofType: PlacementBlockerComponent.self),
                  let pos = entity.component(ofType: SpriteComponent.self)?.position else { continue }
            if hypot(pos.x - point.x, pos.y - point.y) < blocker.radius + minPlacementSpacing / 2 {
                return true
            }
        }
        return false
    }

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.13, green: 0.11, blue: 0.16, alpha: 1)
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0, y: 0)

        humansLayer.zPosition = 2
        towersLayer.zPosition = 1
        trapsLayer.zPosition = 1
        projectilesLayer.zPosition = 5
        fxLayer.zPosition = 4
        addChild(humansLayer)
        addChild(towersLayer)
        addChild(trapsLayer)
        addChild(projectilesLayer)
        addChild(fxLayer)

        registry = EntityRegistry(systems: [
            EffectsSystem(),
            PathFollowSystem(),
            SpawnerSystem(),
            HomingSystem(),
            LifetimeSystem(),
            ProximityTriggerSystem(),
            PathRunnerSystem(),
            SlowAuraSystem(),
            StateMachineSystem(),
        ])

        pathManager = PathManager(scene: self, tileSize: tileSize)
        pathManager.setup()

        let spawner = SpawnerEntity(interval: 3) { [weak self] in
            self?.spawnHuman()
        }
        registry.add(spawner)
    }

    override func update(_ currentTime: TimeInterval) {
        let dt: TimeInterval
        if lastUpdateTime == 0 {
            dt = 0
        } else {
            dt = currentTime - lastUpdateTime
        }
        lastUpdateTime = currentTime
        registry?.update(deltaTime: dt)
        flushPendingRemovals()
    }

    private func flushPendingRemovals() {
        guard !pendingRemovals.isEmpty else { return }
        let batch = pendingRemovals
        pendingRemovals.removeAll(keepingCapacity: true)
        for entity in batch {
            registry.remove(entity)
            if let node = entity.component(ofType: SpriteComponent.self)?.node, node.parent != nil {
                node.removeFromParent()
            }
        }
    }

    // MARK: - Spawn / install

    func spawnHuman() {
        guard let pathManager else { return }
        let entity = HumanEntity(waypoints: pathManager.waypoints)
        if let pf = entity.component(ofType: PathFollowComponent.self) {
            pf.onArrive = { [weak self, weak entity] in
                guard let self, let entity else { return }
                self.removeEntity(entity)
            }
        }
        if let health = entity.component(ofType: HealthComponent.self),
           let sprite = entity.component(ofType: SpriteComponent.self) {
            health.onDeath = { [weak self, weak entity] in
                guard let self, let entity else { return }
                let node = sprite.node
                node.removeAllActions()
                node.run(.sequence([.fadeOut(withDuration: 0.15), .removeFromParent()]))
                self.removeEntity(entity)
            }
        }
        installEntity(entity, in: humansLayer)
    }

    func spawnTower(_ character: CharacterData, at point: CGPoint) {
        let entity = TowerEntity(character: character)
        entity.component(ofType: SpriteComponent.self)?.position = point
        installEntity(entity, in: towersLayer)
    }

    func spawnProjectile(from origin: CGPoint,
                         target: GameEntity,
                         launcher: ProjectileLauncherComponent) {
        let entity = ProjectileEntity(from: origin, target: target, launcher: launcher)

        if let homing = entity.component(ofType: HomingComponent.self) {
            homing.onImpact = { [weak self, weak entity] point, target in
                guard let self, let entity else { return }
                if let damage = entity.component(ofType: DamageOnHitComponent.self) {
                    if let aoe = damage.aoeRadius {
                        self.applyAoEDamage(at: point, radius: aoe, amount: damage.damage, color: damage.color)
                    } else if let target,
                              let health = target.component(ofType: HealthComponent.self) {
                        health.takeDamage(damage.damage)
                    }
                }
                self.removeEntity(entity)
            }
            homing.onTargetLost = { [weak self, weak entity] in
                guard let self, let entity else { return }
                self.removeEntity(entity)
            }
        }
        if let lifetime = entity.component(ofType: LifetimeComponent.self) {
            lifetime.onExpire = { [weak self, weak entity] in
                guard let self, let entity else { return }
                self.removeEntity(entity)
            }
        }

        installEntity(entity, in: projectilesLayer)
    }

    func applyAoEDamage(at point: CGPoint, radius: CGFloat, amount: CGFloat, color: SKColor) {
        let flash = SKShapeNode(circleOfRadius: radius)
        flash.position = point
        flash.fillColor = color.withAlphaComponent(0.35)
        flash.strokeColor = color
        flash.lineWidth = 2
        fxLayer.addChild(flash)
        flash.run(.sequence([
            .group([.fadeOut(withDuration: 0.25), .scale(to: 1.2, duration: 0.25)]),
            .removeFromParent()
        ]))

        for human in registry.humans {
            guard let pos = human.component(ofType: SpriteComponent.self)?.position,
                  let health = human.component(ofType: HealthComponent.self), health.isAlive else { continue }
            if hypot(pos.x - point.x, pos.y - point.y) <= radius {
                health.takeDamage(amount)
            }
        }
    }

    func installEntity(_ entity: GameEntity, in layer: SKNode) {
        if let node = entity.component(ofType: SpriteComponent.self)?.node {
            layer.addChild(node)
        }
        registry.add(entity)
    }

    func removeEntity(_ entity: GameEntity) {
        pendingRemovals.append(entity)
    }

    // MARK: - Placement

    func pathBackward(from point: CGPoint) -> [CGPoint] {
        pathManager.backwardPath(from: point)
    }

    func canPlace(_ character: CharacterData, at scenePoint: CGPoint) -> Bool {
        if tooCloseToExisting(scenePoint) { return false }
        guard let pathManager else { return false }
        let dist = pathManager.distanceToPath(scenePoint)
        let ghostRadius = GhostMetrics.diameter / 2
        let pathHalf = pathManager.pathHalfWidth
        switch character.kind {
        case .tower: return dist > ghostRadius + pathHalf
        case .trap:  return dist + ghostRadius <= pathHalf
        }
    }

    func place(_ character: CharacterData, at scenePoint: CGPoint) {
        guard canPlace(character, at: scenePoint) else { return }
        switch character.kind {
        case .tower: spawnTower(character, at: scenePoint)
        case .trap:  spawnTrap(character, at: scenePoint)
        }
    }

    func spawnTrap(_ character: CharacterData, at point: CGPoint) {
        let entity = TrapEntity(character: character, pathWaypoints: pathManager.waypoints)
        entity.component(ofType: SpriteComponent.self)?.position = point

        if let trigger = entity.component(ofType: ProximityTriggerComponent.self) {
            trigger.onTrigger = { [weak entity] _ in
                guard let entity,
                      let sm = entity.component(ofType: StateMachineComponent.self) else { return }
                switch character.id {
                case .yayang: sm.stateMachine.enter(YayangTriggeredState.self)
                case .yuyul:  sm.stateMachine.enter(YuyulTriggeredState.self)
                default: break
                }
            }
        }
        installEntity(entity, in: trapsLayer)
    }
}
