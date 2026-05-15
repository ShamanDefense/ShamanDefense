//
//  ButtonComponent.swift
//  ShamanDefense
//
//  Created by Richie Daryl Kwenandar on 06/05/26.
//

import SpriteKit

final class GameButtonNode: SKNode {

    let buttonName: String

    init(
        text: String,
        width: CGFloat,
        height: CGFloat,
        fontSize: CGFloat,
        assetName: String = "button",
        buttonName: String
    ) {

        self.buttonName = buttonName

        super.init()

        name = buttonName

        let bg = SKSpriteNode(imageNamed: assetName)
        bg.size = CGSize(
            width: width,
            height: height
        )
        bg.name = buttonName
        addChild(bg)

        let label = SKLabelNode(
            fontNamed: "Newyear Coffee"
        )
        label.text = text
        label.fontSize = fontSize
        label.fontColor = UIColor(
            white: 0.2,
            alpha: 1
        )
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.name = buttonName
        addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateTap() {

        run(.sequence([
            .scale(to: 0.94, duration: 0.05),
            .scale(to: 1.0, duration: 0.05)
        ]))
    }
}


