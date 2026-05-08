//
//  GhostNode.swift
//  ShamanDefense
//

import SpriteKit

class GhostNode: SKShapeNode {
    init(displayName: String, fillColor: SKColor) {
        super.init()
        let d = GhostMetrics.diameter
        let r = d / 2
        path = CGPath(ellipseIn: CGRect(x: -r, y: -r, width: d, height: d), transform: nil)
        self.fillColor = fillColor
        strokeColor = SKColor.black.withAlphaComponent(0.4)
        lineWidth = 1

        let label = SKLabelNode(text: displayName)
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 10
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        addChild(label)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
}
