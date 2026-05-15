//
//  GameOverNode.swift
//  ShamanDefense
//

import SpriteKit

final class GameOverNode: SKNode {
    
    var onRetry:    (() -> Void)?
    var onMainMenu: (() -> Void)?
    
    init(score: Int, highScore: Int, isFirstPlay: Bool, sceneSize: CGSize) {
        super.init()
        buildUI(score: score, highScore: highScore, isFirstPlay: isFirstPlay, sceneSize: sceneSize)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
    
    private func buildUI(score: Int, highScore: Int, isFirstPlay: Bool, sceneSize: CGSize) {
        
        let dim = SKShapeNode(rectOf: sceneSize)
        dim.fillColor = UIColor.black.withAlphaComponent(0.55)
        dim.strokeColor = .clear
        dim.zPosition = 0
        addChild(dim)
        
        let panel = SKSpriteNode(imageNamed: "gameover_panel")
        
        panel.size = CGSize(
            width: sceneSize.width * 0.68,
            height: sceneSize.height * 0.55
        )
        
        panel.position = CGPoint(x: 0, y: -50)
        panel.zPosition = 1
        
        addChild(panel)
        
        let title = SKSpriteNode(imageNamed: "gameover_text")
        
        title.size = CGSize(
            width: sceneSize.width * 0.72,
            height: sceneSize.height * 0.26
        )
        
        title.position = CGPoint(
            x: 0,
            y: panel.size.height * 0.60
        )
        
        title.zPosition = 2
        
        panel.addChild(title)
        
        let scoreLabel = GameLabelNode(
            text: String(score),
            fontSize: 68
        )
        scoreLabel.position = CGPoint(x: 0, y: 85)
        scoreLabel.zPosition = 2
        panel.addChild(scoreLabel)
        
        if !isFirstPlay {
            
            let hsLabel = GameLabelNode(
                text: "HIGH SCORE: \(highScore)",
                fontSize: 25
            )
            
            hsLabel.position = CGPoint(x: 0, y: 25)
            
            hsLabel.zPosition = 2
            
            panel.addChild(hsLabel)
        }
        
        let retryButton = GameButtonNode(
            text: "retry",
            width: panel.size.width * 0.85,
            height: 70,
            fontSize: 38,
            buttonName: "btnRetry"
        )
        
        retryButton.position = CGPoint(x: 0, y: -55)
        panel.addChild(retryButton)
        
        let homeButton = GameButtonNode(
            text: "BACK TO HOME",
            width: panel.size.width * 0.65,
            height: 55,
            fontSize: 20,
            buttonName: "btnMainMenu"
        )
        
        homeButton.position = CGPoint(x: 0, y: -130)
        panel.addChild(homeButton)
        
        alpha = 0
        setScale(0.88)
        
        run(.group([
            .fadeIn(withDuration: 0.25),
            .scale(to: 1.0, duration: 0.25)
        ]))
    }
    
    func handleTap(at location: CGPoint) {
        
        guard let parent else { return }
        
        let localPoint = convert(location, from: parent)
        
        for node in nodes(at: localPoint) {
            
            switch node.name {
                
            case "btnRetry":
                
                (node.parent as? GameButtonNode)?.animateTap()
                onRetry?()
                
            case "btnMainMenu":
                
                (node.parent as? GameButtonNode)?.animateTap()
                onMainMenu?()
                
            default:
                break
            }
        }
    }
}
