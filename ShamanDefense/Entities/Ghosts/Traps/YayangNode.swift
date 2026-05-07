//
//  YayangNode.swift
//  ShamanDefense
//
//  Created by Richie Daryl Kwenandar on 06/05/26.
//

import SpriteKit
import SwiftUI

final class YayangNode: SKSpriteNode {
    init() {
        super.init(texture: nil, color: .systemPink, size: CGSize(width: 56, height: 56))

        let label = SKLabelNode(text: "Yayang")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 12
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        addChild(label)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
}
