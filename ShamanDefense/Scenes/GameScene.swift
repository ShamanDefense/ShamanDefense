//
//  GameScene.swift
//  ShamanDefense
//
//  Created by Richie Daryl Kwenandar on 06/05/26.
//

import SpriteKit
import SwiftUI

enum TileVariant {
    case straightH, straightV
    case cornerTR, cornerTL, cornerBR, cornerBL
}

final class GameScene: SKScene {

    private let tileSize: CGFloat = 36
    private var pathManager: PathManager!
    private var waveManager: WaveManager!

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.13, green: 0.11, blue: 0.16, alpha: 1)
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0, y: 0)

        pathManager = PathManager(scene: self, tileSize: tileSize)
        pathManager.setup()

        waveManager = WaveManager(scene: self, waypoints: pathManager.waypoints, tileSize: tileSize)
        waveManager.start()
    }

    func place(_ character: CharacterData, at scenePoint: CGPoint) {
        let node = Self.makeNode(for: character)
        node.position = scenePoint
        addChild(node)
    }

    static func makeNode(for character: CharacterData) -> SKSpriteNode {
        switch character.id {
        case .keti:   return KetiNode()
        case .poci:   return PociNode()
        case .gugun:  return GugunNode()
        case .yayang: return YayangNode()
        case .yuyul:  return YuyulNode()
        }
    }
}
