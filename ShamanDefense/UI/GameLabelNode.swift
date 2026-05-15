//
//  GameLabelNode.swift
//  ShamanDefense
//
//  Created by Richie Daryl Kwenandar on 15/05/26.
//

import SpriteKit

final class GameLabelNode: SKLabelNode {
    
    init(
        text: String,
        fontSize: CGFloat,
        color: UIColor = UIColor(white: 0.25, alpha: 1)) {
        
        super.init()
        self.text = text
        self.fontName = "Newyear Coffee"
        self.fontSize = fontSize
        self.fontColor = color
        self.verticalAlignmentMode = .center
        self.horizontalAlignmentMode = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
