//
//  GameScene.swift
//  ShamanDefense
//
//  Created by Richie Daryl Kwenandar on 06/05/26.
//

import SpriteKit

enum TileVariant {
    case straightH, straightV
    case cornerTR, cornerTL, cornerBR, cornerBL
}

class GameScene: SKScene {
    
    private let tileSize: CGFloat = 36
    private var pathManager: PathManager!
    private var waveManager: WaveManager!
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.13, green: 0.11, blue: 0.16, alpha: 1)
        
        pathManager = PathManager(scene: self, tileSize: tileSize)
        pathManager.setup()
        
        waveManager = WaveManager(scene: self, waypoints: pathManager.waypoints, tileSize: tileSize)
        waveManager.start()
    }
}
