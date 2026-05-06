//
//  YuyulNode.swift
//  ShamanDefense
//
//  Created by Richie Daryl Kwenandar on 06/05/26.
//

import SpriteKit
import SwiftUI

final class YuyulNode: SKNode {
    override init() {
        super.init()

        let body = SKShapeNode(circleOfRadius: 28)
        body.fillColor = UIColor.purple
        body.strokeColor = .black
        body.lineWidth = 2
        addChild(body)

        let label = SKLabelNode(text: "Yuyul")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 12
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        addChild(label)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
}
