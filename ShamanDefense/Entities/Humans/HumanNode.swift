//
//  HumanNode.swift
//  ShamanDefense
//
//  Created by Richie Daryl Kwenandar on 06/05/26.
//

import SpriteKit

class HumanNode: SKNode {
    private let moveSpeed: CGFloat = 100

    private(set) var hp: CGFloat = 1

    override init () {
        super.init()
        let iconLabel = SKLabelNode(text: "🏃🏻‍➡️")
        iconLabel.fontSize = 40
        iconLabel.verticalAlignmentMode = .center
        addChild(iconLabel)
    }

    required init?(coder: NSCoder) {fatalError()}

    func takeDamage(_ amount: CGFloat) {
        guard hp > 0 else { return }
        hp = max(0, hp - amount)
        if hp <= 0 {
            removeAllActions()
            run(.sequence([.fadeOut(withDuration: 0.15), .removeFromParent()]))
        }
    }

    func applySlow(factor: CGFloat, duration: TimeInterval) {
        speed = factor
        guard let scene else { return }
        scene.run(.sequence([
            .wait(forDuration: duration),
            .run { [weak self] in self?.speed = 1 }
        ]))
    }

    func applyFreeze(duration: TimeInterval) {
        isPaused = true
        guard let scene else { return }
        scene.run(.sequence([
            .wait(forDuration: duration),
            .run { [weak self] in self?.isPaused = false }
        ]))
    }
    
    func followPath(_ waypoints: [CGPoint], curveRadius: CGFloat = 40) {
        guard waypoints.count > 1 else { return }
        let smoothPath = buildCurvedPath(waypoints: waypoints, curveRadius: curveRadius)
        
        let follow = SKAction.follow(
            smoothPath,
            asOffset:     false,
            orientToPath: false,
            speed:        moveSpeed
        )
        run(.sequence([follow, .removeFromParent()]))
    }
    
    private func buildCurvedPath(waypoints: [CGPoint], curveRadius: CGFloat) -> CGPath {
        let path = CGMutablePath()
        path.move(to: waypoints[0])
        
        for i in 1..<waypoints.count - 1 {
            let prev   = waypoints[i - 1]
            let corner = waypoints[i]
            let next   = waypoints[i + 1]
            
            // Vektor masuk (dari prev ke corner), dinormalisasi
            let d1  = hypot(corner.x - prev.x, corner.y - prev.y)
            let dx1 = (corner.x - prev.x) / d1
            let dy1 = (corner.y - prev.y) / d1
            
            // Vektor keluar (dari corner ke next), dinormalisasi
            let d2  = hypot(next.x - corner.x, next.y - corner.y)
            let dx2 = (next.x - corner.x) / d2
            let dy2 = (next.y - corner.y) / d2
            
            // Pastikan radius tidak melebihi setengah panjang segmen
            // agar kurva tidak overlap antar dua corner yang berdekatan
            let r = min(curveRadius, d1 / 2, d2 / 2)
            
            // Titik di mana kurva dimulai (sebelum corner)
            let curveStart = CGPoint(
                x: corner.x - dx1 * r,
                y: corner.y - dy1 * r
            )
            
            // Titik di mana kurva berakhir (setelah corner)
            let curveEnd = CGPoint(
                x: corner.x + dx2 * r,
                y: corner.y + dy2 * r
            )
            
            // Lurus menuju titik awal kurva
            path.addLine(to: curveStart)
            
            path.addQuadCurve(to: curveEnd, control: corner)
        }
        
        // Lurus ke waypoint terakhir
        path.addLine(to: waypoints.last!)
        
        return path
    }
}
