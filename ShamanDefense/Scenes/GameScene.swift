//
//  GameScene.swift
//  ShamanDefense
//
//  Created by Richie Daryl Kwenandar on 06/05/26.
//

import SpriteKit
import SwiftUI

final class GameScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(Color.green)
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0, y: 0)
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
