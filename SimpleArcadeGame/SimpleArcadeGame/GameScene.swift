//
//  GameScene.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 2/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Rectangle to ensure everything is visible for all devices (iPads & iPhones)
    let playableRect: CGRect!
    // Parent node of gameplay elements
    let worldNode = SKNode()
    // Parent node of all UI elements
    let uiNode = SKNode()
    
    var highScoreLabel: SKLabelNode!
    var highScore:Int = 0 {
        didSet {
            highScoreLabel.text = String("Best: \(highScore)")
        }
    }
    var scoreLabel: SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel?.text = String("Score: \(score)")
        }
    }
    
    var coinsIcon: SKSpriteNode!
    var coinsLabel: SKLabelNode!
    var coins:Int = 0 {
        didSet {
            coinsLabel.text = String("\(coins)")
        }
    }
    
    //Shop
    var shopButton: SKSpriteNode!
    //Leaderboard
    var leaderboardButton:SKSpriteNode!
    
    var button1:SKSpriteNode!
    var button2:SKSpriteNode!
    var button3:SKSpriteNode!
    
    // Provides a way to position elements relative to screen size. Taken from:
    // https:github.com/jozemite/Spritekit-Universal-Game
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0
        
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        debugAreaPlayableArea()
        addChild(worldNode)
        addChild(uiNode)
        
        initialiseLevel()
        initialiseUi()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPosition = touch.location(in: self)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func initialiseLevel() {
        createButtons()
    }
    
    func createButtons() {
        button1 = Button(name: "button1", image: SKTexture(imageNamed: "sd"))
        button1.position = CGPoint(x: size.width*0.35, y: playableRect.maxY*0.38)
        button1.zPosition = 2
        worldNode.addChild(button1)
        
        button2 = Button(name: "button2", image: SKTexture(imageNamed: "sd"))
        button2.position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.38)
        button2.zPosition = 2
        worldNode.addChild(button2)
        
        button3 = Button(name: "button2", image: SKTexture(imageNamed: "sd"))
        button3.position = CGPoint(x: size.width*0.65, y: playableRect.maxY*0.38)
        button3.zPosition = 2
        worldNode.addChild(button3)
        
        //Shop
        shopButton = SKSpriteNode(texture: SKTexture(imageNamed: "sd"))
        shopButton.zPosition = 3
        if UIDevice.current.userInterfaceIdiom == .pad {
            shopButton.position = CGPoint(x: size.width*0.89, y: size.height*0.22)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            shopButton.position = CGPoint(x: size.width*0.89, y: playableRect.maxY*0.22)
        }
        shopButton.name = "ShopButton"
        shopButton.size = CGSize(width: 200, height: 100)
        uiNode.addChild(shopButton)
        
        //Leaderboard
        leaderboardButton = SKSpriteNode(texture: SKTexture(imageNamed: "sd"))
        leaderboardButton.zPosition = 3
        if UIDevice.current.userInterfaceIdiom == .pad {
            leaderboardButton.position = CGPoint(x: size.width*0.89, y: size.height*0.33)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            leaderboardButton.position = CGPoint(x: size.width*0.89, y: playableRect.maxY*0.33)
        }
        leaderboardButton.name = "AchievementButton"
        leaderboardButton.size = CGSize(width: 150, height: 150)
        uiNode.addChild(leaderboardButton)
    }
    
    func initialiseUi() {
        highScoreLabel = SKLabelNode()
        
        //Check what device user is on
        if UIDevice.current.userInterfaceIdiom == .pad {
            highScoreLabel.position = CGPoint(x: size.width*0.9, y: size.height*0.93)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            highScoreLabel.position = CGPoint(x: size.width*0.9, y: playableRect.maxY*0.93)
        }
        highScoreLabel.zPosition = 4
        highScoreLabel.text = String("Best: \(highScore)")
        highScoreLabel.fontName = "Palatino-Bold"
        highScoreLabel.fontColor = SKColor.black
        highScoreLabel.fontSize = 79
        highScoreLabel.verticalAlignmentMode = .center
        highScoreLabel.horizontalAlignmentMode = .center
        uiNode.addChild(highScoreLabel)
        
        scoreLabel = SKLabelNode()
        if UIDevice.current.userInterfaceIdiom == .pad {
            scoreLabel.position = CGPoint(x: size.width*0.5, y: size.height*0.93)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            scoreLabel.position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.93)
        }
        scoreLabel.zPosition = 4
        scoreLabel.text = String("Score: \(score)")
        scoreLabel.fontName = "Palatino-Bold"
        scoreLabel.fontColor = SKColor.black
        scoreLabel.fontSize = 85
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.horizontalAlignmentMode = .center
        uiNode.addChild(scoreLabel)
        
        //Coins
        coinsLabel = SKLabelNode()
        if UIDevice.current.userInterfaceIdiom == .pad {
            coinsLabel.position = CGPoint(x: size.width*0.072, y: size.height*0.84)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            coinsLabel.position = CGPoint(x: size.width*0.072, y: playableRect.maxY*0.84)
        }
        coinsLabel.zPosition = 4
        coinsLabel.text = String("\(coins)")
        coinsLabel.fontName = "Palatino-Bold"
        coinsLabel.fontColor = SKColor.yellow
        coinsLabel.fontSize = 80
        coinsLabel.verticalAlignmentMode = .center
        coinsLabel.horizontalAlignmentMode = .left
        uiNode.addChild(coinsLabel)
        
        //TODO: change image
        coinsIcon = SKSpriteNode(texture: SKTexture(imageNamed: "sd"))
        if UIDevice.current.userInterfaceIdiom == .pad {
            coinsIcon.position = CGPoint(x: size.width*0.04, y: size.height*0.84)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            coinsIcon.position = CGPoint(x: size.width*0.04, y: playableRect.maxY*0.84)
        }
        coinsIcon.zPosition = 4
        coinsIcon.size = CGSize(width: 85, height: 85)
        coinsIcon.name = "CoinsIcon"
        uiNode.addChild(coinsIcon)
    }
    
    //Helper methods
    func debugAreaPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
}
