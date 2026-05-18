//
//  MainMenuScene.swift
//  ShamanDefense
//
//  Created by Michael on 15/05/26.
//

import SwiftUI
import SpriteKit

class MainMenuScene: SKScene {
    
    private let viewModel = MainMenuViewModel()
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupLogo()
        setupSettingsButton()
        setupScoreBoard()
        setupStartButton()
        setupCharactersButton()
        setupCharacter()
    }
    
    // MARK: - Background
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = CGPoint(x: size.width / 2,
                                      y: size.height / 2)
        
        background.size = size
        background.zPosition = -1
        
        addChild(background)
    }
    
    // MARK: - Logo
    
    private func setupLogo() {
        let logo = SKSpriteNode(imageNamed: "logo")
        
        logo.position = CGPoint(x: size.width / 2,
                                y: size.height * 0.78)
        
        logo.size = CGSize(width: 337, height: 132)
        logo.zPosition = 5
        addChild(logo)
    }
    
    // MARK: - Settings
    
    private func setupSettingsButton() {
        let settings = SKSpriteNode(imageNamed: "settings_button")
        
        settings.name = "settings"
        
        settings.position = CGPoint(x: size.width - 50,
                                    y: size.height - 80)
        
        settings.size = CGSize(width: 58, height: 59)
        
        addChild(settings)
    }
    
    // MARK: - Score
    
    private func setupScoreBoard() {
        let board = SKSpriteNode(imageNamed: "score_board")
        
        board.position = CGPoint(x: size.width / 1.7,
                                 y: size.height * 0.68)
        
        board.size = CGSize(width: 166, height: 132)
        board.zRotation = -0.15
        board.zPosition = 1

        addChild(board)
        
        let highScoreLabel = SKLabelNode(fontNamed: "Newyear Coffee")

            highScoreLabel.text = "High Score:"
            highScoreLabel.fontSize = 10
            highScoreLabel.fontColor = SKColor(red: 75 / 255, green: 75 / 255, blue: 75 / 255, alpha: 1)
            highScoreLabel.position = CGPoint(x: 20, y: -30)

            board.addChild(highScoreLabel)


        let label = SKLabelNode(fontNamed: "Newyear Coffee")
        

        label.text = "0000"
        label.fontSize = 30
        label.fontColor = SKColor(red: 75 / 255, green: 75 / 255, blue: 75 / 255, alpha: 1)

        
        label.position = CGPoint(x: 20, y: -55)
        
        board.addChild(label)
    }
    
    // MARK: - Start Button
    
    private func setupStartButton() {
        let start = SKSpriteNode(imageNamed: "start_button")
        
        start.name = "start"
        
        start.position = CGPoint(x: size.width / 2,
                                 y: size.height * 0.5)
        
        start.size = CGSize(width: 254, height: 138)
        
        addChild(start)
        
        let label = SKLabelNode(fontNamed: "Newyear Coffee")
        
        label.text = "Start"
        label.fontSize = 50
        label.fontColor = SKColor(red: 75 / 255, green: 75 / 255, blue: 75 / 255, alpha: 1)
        
        label.position = CGPoint(x: 0, y: 0)
        
        start.addChild(label)
    }
    
    // MARK: - Character Button
    
    private func setupCharactersButton() {
        let characters = SKSpriteNode(imageNamed: "characters_button")
        
        characters.name = "characters"
        
        characters.position = CGPoint(x: size.width / 2,
                                      y: size.height * 0.43)
        
        characters.size = CGSize(width: 165, height: 52)
        
        addChild(characters)
        
        let label = SKLabelNode(fontNamed: "Newyear Coffee")
        
        label.text = "Characters"
        label.fontSize = 20
        label.fontColor = SKColor(red: 75 / 255, green: 75 / 255, blue: 75 / 255, alpha: 1)
        
        label.position = CGPoint(x: 0, y: -8)
        
        characters.addChild(label)
    }
    
    // MARK: - Main Character
    
    private func setupCharacter() {
        let character = SKSpriteNode(imageNamed: "character")
        
        character.position = CGPoint(x: size.width / 2,
                                     y: size.height * 0.10)
        
        character.size = CGSize(width: 285, height: 367)
        
        addChild(character)
    }
    
    // MARK: - Touch
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        let touchedNode = atPoint(location)
        
        switch touchedNode.name {
            
        case "start":
            viewModel.startGame()
            
        case "characters":
            viewModel.openCharacters()
            
        case "settings":
            viewModel.openSettings()
            
        default:
            break
        }
    }
    
}

#Preview {
    let scene = MainMenuScene(size: CGSize(width: 390, height: 844))
    scene.scaleMode = .aspectFill
    return SpriteView(scene: scene)
        .ignoresSafeArea()
}
