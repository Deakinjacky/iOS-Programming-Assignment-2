//
//  GameScene.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 2/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let invulnerable: UInt32 = 0b1
    static let boundary: UInt32 = 0b10
    static let goal: UInt32 = 0b100
    static let enemy: UInt32 = 0b1000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Rectangle to ensure everything is visible for all devices (iPads & iPhones)
    let playableRect: CGRect!
    // Parent node of gameplay elements
    let worldNode = SKNode()
    // Parent node of all UI elements
    let uiNode = SKNode()
    
    var background:SKSpriteNode!
    var initialEnemy:SKSpriteNode!
    var goal:SKSpriteNode!
    
    var highScoreLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var score:Int = -1 {
        didSet {
            scoreLabel?.text = String("Score: \(score)")
            defeatScoreLabel?.text = String("Score: \(score)")
        }
    }
    
    var coinsIcon: SKSpriteNode!
    var coinsLabel: SKLabelNode!
    var shopCoinsLabel:SKLabelNode!
    
    //Shop
    var shopButton: SKSpriteNode!
    var shopBackground:SKSpriteNode!
    var shopBuyButton1:SKSpriteNode!
    var shopBuyButton2:SKSpriteNode!
    var crossButton:SKSpriteNode!
    //Items
    var item1:SKSpriteNode!
    var item1Number:SKLabelNode!
    var item2:SKSpriteNode!
    var item2Number:SKLabelNode!
    //Leaderboard
    var leaderboardButton:SKSpriteNode!
    
    var button1:SKSpriteNode!
    var button2:SKSpriteNode!
    var button3:SKSpriteNode!
    var invokeButton: SKSpriteNode!
    //Elements - Indicators of what player pressed
    var element1:Int = 0
    var element1Name:String = ""
    var element1Position:CGPoint = CGPoint(x: 0, y: 0)
    var element2:Int = 0
    var element2Name:String = ""
    var element2Position:CGPoint = CGPoint(x: 0, y: 0)
    var element3:Int = 0
    var element3Name:String = ""
    var element3Position:CGPoint = CGPoint(x: 0, y: 0)
    //Element Icons
    var redElementIcon:SKSpriteNode!
    var redElement2Icon:SKSpriteNode!
    var redElement3Icon:SKSpriteNode!
    var blueElementIcon:SKSpriteNode!
    var blueElement2Icon:SKSpriteNode!
    var blueElement3Icon:SKSpriteNode!
    var greenElementIcon:SKSpriteNode!
    var greenElement2Icon:SKSpriteNode!
    var greenElement3Icon:SKSpriteNode!
    
    var tutorialPage:SKSpriteNode!
    var tutorialAnim:[SKTexture]!
    
    //Settings
    var soundButton:SKSpriteNode!
    var musicButton:SKSpriteNode!
    
    //Hearts
    var health1: SKSpriteNode!
    var health2: SKSpriteNode!
    var health3: SKSpriteNode!
    var healthPoints:Int = 3 {
        didSet {
            if healthPoints == 3 {
                health1?.alpha = 1.0
                health2?.alpha = 1.0
                health3?.alpha = 1.0
            }
            else if healthPoints == 2 {
                health1?.alpha = 1.0
                health2?.alpha = 1.0
                health3?.alpha = 0.0
            }
            else if healthPoints == 1 {
                health1?.alpha = 1.0
                health2?.alpha = 0.0
                health3?.alpha = 0.0
            }
            else {
                health1?.alpha = 0.0
                health2?.alpha = 0.0
                health3?.alpha = 0.0
            }
        }
    }
    
    var gameWaitTime:Int = 4
    var redEnemyAnimation:[SKTexture]!
    var blueEnemyAnimation:[SKTexture]!
    var greenEnemyAnimation:[SKTexture]!
    var yellowEnemyAnimation:[SKTexture]!
    var pinkEnemyAnimation:[SKTexture]!
    var fastEnemyAnimation:[SKTexture]!
    var chargeEnemyAnimation:[SKTexture]!
    var invisEnemyAnimation:[SKTexture]!
    var darknessEnemyAnimation:[SKTexture]!
    
    //Used for darkness mechanic in SpawnComplexEnemies(_dark)
    var darknessScreen: SKSpriteNode!
    
    var coinAnimation:[SKTexture]!
    
    //Defeat
    var defeatScreen:SKSpriteNode!
    var defeatRetryButton:SKSpriteNode!
    var defeatScoreLabel:SKLabelNode!
    var defeatBestScoreLabel:SKLabelNode!
    
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
        
        //Physics World - Set up a physics body around the screen
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.friction = 0
        physicsBody!.categoryBitMask = PhysicsCategory.boundary
        physicsBody!.collisionBitMask = PhysicsCategory.boundary
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        initialiseLevel()
        initialiseUi()
        //Destroy this bird to start game
        spawnInitialRedEnemy()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPosition = touch.location(in: self)
          
            if button1.contains(touchPosition) {
                //Make button 'bounce' - More satisfying for users
                button1.run(SKAction.sequence([SKAction.resize(byWidth: -20, height: -20, duration: 0.05),SKAction.resize(byWidth: 20, height: 20, duration: 0.05)]))
                createElement(name: button1.name!)
            }
            else if button2.contains(touchPosition) {
                button2.run(SKAction.sequence([SKAction.resize(byWidth: -20, height: -20, duration: 0.05),SKAction.resize(byWidth: 20, height: 20, duration: 0.05)]))
                createElement(name: button2.name!)
            }
            else if button3.contains(touchPosition) {
                button3.run(SKAction.sequence([SKAction.resize(byWidth: -20, height: -20, duration: 0.05),SKAction.resize(byWidth: 20, height: 20, duration: 0.05)]))
                createElement(name: button3.name!)
            }
            if invokeButton.contains(touchPosition) {
                invokeButton.run(SKAction.sequence([SKAction.resize(byWidth: -20, height: -20, duration: 0.05),SKAction.resize(byWidth: 20, height: 20, duration: 0.05)]))
                invoke()
            }
            if shopButton.contains(touchPosition) {
                shopButton.run(SKAction.sequence([SKAction.resize(byWidth: -30, height: -30, duration: 0.05),SKAction.resize(byWidth: 30, height: 30, duration: 0.05)]),completion:{[unowned self] in self.showShop()})
            }
            else if crossButton.contains(touchPosition) {
                crossButton.run(SKAction.sequence([SKAction.resize(byWidth: -25, height: -25, duration: 0.05),SKAction.resize(byWidth: 25, height: 25, duration: 0.05)]),completion:{[unowned self] in self.hideShop()})
            }
            else if shopBuyButton1.contains(touchPosition) {
                shopBuyButton1.run(SKAction.sequence([SKAction.resize(byWidth: -25, height: -25, duration: 0.05),SKAction.resize(byWidth: 25, height: 25, duration: 0.05)]))
                buyItem(cost: 50, itemNumber: 1)
            }
            else if shopBuyButton2.contains(touchPosition) {
                shopBuyButton2.run(SKAction.sequence([SKAction.resize(byWidth: -25, height: -25, duration: 0.05),SKAction.resize(byWidth: 25, height: 25, duration: 0.05)]))
                buyItem(cost: 50, itemNumber: 2)
            }
            //Items
            if item1.contains(touchPosition) {
                item1.run(SKAction.sequence([SKAction.resize(byWidth: -25, height: -25, duration: 0.05),SKAction.resize(byWidth: 25, height: 25, duration: 0.05)]))
                useItem1()
            }
            else if item2.contains(touchPosition) {
                item2.run(SKAction.sequence([SKAction.resize(byWidth: -25, height: -25, duration: 0.05),SKAction.resize(byWidth: 25, height: 25, duration: 0.05)]))
                useItem2()
            }
            
            if leaderboardButton.contains(touchPosition) {
                leaderboardButton.run(SKAction.sequence([SKAction.resize(byWidth: -30, height: -30, duration: 0.05),SKAction.resize(byWidth: 30, height: 30, duration: 0.05)]))
            }
            if soundButton.contains(touchPosition) {
                soundButton.run(SKAction.sequence([SKAction.resize(byWidth: -30, height: -30, duration: 0.05),SKAction.resize(byWidth: 30, height: 30, duration: 0.05)]))
                toggleSoundFx()
            }
            else if musicButton.contains(touchPosition) {
                musicButton.run(SKAction.sequence([SKAction.resize(byWidth: -30, height: -30, duration: 0.05),SKAction.resize(byWidth: 30, height: 30, duration: 0.05)]))
                toggleMusic()
            }
            //Defeat
            if defeatRetryButton.contains(touchPosition) {
                defeatRetryButton.run(SKAction.sequence([SKAction.resize(byWidth: -25, height: -25, duration: 0.05),SKAction.resize(byWidth: 25, height: 25, duration: 0.05)]))
                hideDefeatScreen()
                showEverything()
                spawnInitialRedEnemy()
            }
        }
    }
    
    //Physics Contact
    func didBegin(_ contact: SKPhysicsContact) {
        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {return}
        if contact.bodyA.node?.name == "goal" || (contact.bodyB.node?.name?.contains("Enemy"))! {
            if let child = contact.bodyA.node as? Enemy {
                //TODO: Shake screen
                child.removeFromParent()
            }
            else if let child = contact.bodyB.node as? Enemy {
                child.removeFromParent()
            }
            
            //Ensure that the enemy won't make contact multiple times
            guard goal.physicsBody?.categoryBitMask == PhysicsCategory.goal else {return}
            
            goal.physicsBody?.categoryBitMask = PhysicsCategory.invulnerable
            goal.run(SKAction.wait(forDuration: 0.1), completion: {[unowned self] in
                self.goal.physicsBody?.categoryBitMask = PhysicsCategory.goal})
            
            healthPoints -= 1
            if healthPoints <= 0 {
                //Show Lose Screen
                showDefeatScreen()
            }
        }
    }
    
    func initialiseLevel() {
        background = SKSpriteNode(texture: SKTexture(imageNamed:"Background"), color: SKColor.clear, size: CGSize(width: 2048, height: 1536))
        background.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        //Appears behind all nodes
        background.zPosition = -10
        addChild(background)
        
        createButtons()
        createShop()
        createItems()
        createEnemyAnimations()
        createDefeatScreen()
        
        //Invisible bar placed at the left side of the screen - When enemy reaches the bar, players loses 1 health
        goal = SKSpriteNode(texture: nil, color: SKColor.green, size: CGSize(width: 10, height: playableRect.maxY))
        goal.position = CGPoint(x: -(size.width*0.1), y: playableRect.maxY*0.5)
        goal.zPosition = 0
        goal.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width*0.005, height: playableRect.maxY))
        goal.physicsBody?.categoryBitMask = PhysicsCategory.goal
        goal.physicsBody?.collisionBitMask = PhysicsCategory.none
        goal.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        goal.physicsBody?.usesPreciseCollisionDetection = true
        goal.name = "Goal"
        worldNode.addChild(goal)
        
        darknessScreen = SKSpriteNode(texture: nil, color: SKColor.black, size: CGSize(width: size.width, height: size.height))
        darknessScreen.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        darknessScreen.zPosition = 3
        darknessScreen.name = "DarknessScreen"
        darknessScreen.alpha = 0.0
        worldNode.addChild(darknessScreen)
    }
    
    func createButtons() {
        button1 = Button(name: "Button1", image: SKTexture(imageNamed: "RedButton"))
        button1.position = CGPoint(x: size.width*0.35, y: playableRect.maxY*0.38)
        button1.zPosition = 2
        worldNode.addChild(button1)
        
        button2 = Button(name: "Button2", image: SKTexture(imageNamed: "BlueButton"))
        button2.position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.38)
        button2.zPosition = 2
        worldNode.addChild(button2)
        
        button3 = Button(name: "Button3", image: SKTexture(imageNamed: "GreenButton"))
        button3.position = CGPoint(x: size.width*0.65, y: playableRect.maxY*0.38)
        button3.zPosition = 2
        worldNode.addChild(button3)
        
        invokeButton = SKSpriteNode(texture: SKTexture(imageNamed: "InvokeButton"))
        invokeButton.size = CGSize(width: 260, height: 150)
        invokeButton.position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.22)
        invokeButton.zPosition = 2
        invokeButton.name = "InvokeButton"
        worldNode.addChild(invokeButton)
        
        //Shop
        shopButton = SKSpriteNode(texture: SKTexture(imageNamed: "ShopButton"))
        shopButton.zPosition = 3
        if UIDevice.current.userInterfaceIdiom == .pad {
            shopButton.position = CGPoint(x: size.width*0.936, y: size.height*0.22)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            shopButton.position = CGPoint(x: size.width*0.936, y: playableRect.maxY*0.22)
        }
        shopButton.name = "ShopButton"
        shopButton.size = CGSize(width: 150, height: 150)
        uiNode.addChild(shopButton)
        
        //Leaderboard
        leaderboardButton = SKSpriteNode(texture: SKTexture(imageNamed: "LeaderboardButton"))
        leaderboardButton.zPosition = 3
        if UIDevice.current.userInterfaceIdiom == .pad {
            leaderboardButton.position = CGPoint(x: size.width*0.936, y: size.height*0.36)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            leaderboardButton.position = CGPoint(x: size.width*0.936, y: playableRect.maxY*0.36)
        }
        leaderboardButton.name = "LeaderboardButton"
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
        highScoreLabel.text = String("Best: \(GameViewController.highScore)")
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
        scoreLabel.alpha = 0.0
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
        coinsLabel.text = String("\(GameViewController.coins)")
        coinsLabel.fontName = "Palatino-Bold"
        coinsLabel.fontColor = SKColor.black
        coinsLabel.fontSize = 80
        coinsLabel.verticalAlignmentMode = .center
        coinsLabel.horizontalAlignmentMode = .left
        uiNode.addChild(coinsLabel)
        
        coinsIcon = SKSpriteNode(texture: SKTexture(imageNamed: "CoinIcon"))
        if UIDevice.current.userInterfaceIdiom == .pad {
            coinsIcon.position = CGPoint(x: size.width*0.04, y: size.height*0.84)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            coinsIcon.position = CGPoint(x: size.width*0.04, y: playableRect.maxY*0.84)
        }
        coinsIcon.zPosition = 4
        coinsIcon.size = CGSize(width: 60, height: 100)
        coinsIcon.name = "CoinsIcon"
        uiNode.addChild(coinsIcon)
        
        //Hearts
        health1 = SKSpriteNode(texture: SKTexture(imageNamed: "health"))
        if UIDevice.current.userInterfaceIdiom == .pad {
            health1.position = CGPoint(x: size.width*0.04, y: size.height*0.93)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            health1.position = CGPoint(x: size.width*0.04, y: playableRect.maxY*0.93)
        }
        health1.zPosition = 4
        health1.size = CGSize(width: 130, height: 110)
        uiNode.addChild(health1)
        
        health2 = SKSpriteNode(texture: SKTexture(imageNamed: "health"))
        if UIDevice.current.userInterfaceIdiom == .pad {
            health2.position = CGPoint(x: size.width*0.112, y: size.height*0.93)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            health2.position = CGPoint(x: size.width*0.112, y: playableRect.maxY*0.93)
        }
        
        health2.zPosition = 4
        health2.size = CGSize(width: 130, height: 110)
        uiNode.addChild(health2)
        
        health3 = SKSpriteNode(texture: SKTexture(imageNamed: "health"))
        if UIDevice.current.userInterfaceIdiom == .pad {
            health3.position = CGPoint(x: size.width*0.183, y: size.height*0.93)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            health3.position = CGPoint(x: size.width*0.183, y: playableRect.maxY*0.93)
        }
        health3.zPosition = 4
        health3.size = CGSize(width: 130, height: 110)
        uiNode.addChild(health3)
        
        //Element Postions
        element1Position = CGPoint(x: size.width*0.4, y: playableRect.maxY*0.505)
        element2Position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.505)
        element3Position = CGPoint(x: size.width*0.6, y: playableRect.maxY*0.505)
        //Element Icons - Indicator for player
        redElementIcon = ElementIcon(image: SKTexture(imageNamed:"redElement"))
        redElementIcon.position = element1Position
        redElementIcon.zPosition = 2
        worldNode.addChild(redElementIcon)
        redElement2Icon = ElementIcon(image: SKTexture(imageNamed:"redElement"))
        redElement2Icon.position = element2Position
        redElement2Icon.zPosition = 2
        worldNode.addChild(redElement2Icon)
        redElement3Icon = ElementIcon(image: SKTexture(imageNamed:"redElement"))
        redElement3Icon.position = element3Position
        redElement3Icon.zPosition = 2
        worldNode.addChild(redElement3Icon)
        
        blueElementIcon = ElementIcon(image: SKTexture(imageNamed:"blueElement"))
        blueElementIcon.position = element1Position
        blueElementIcon.zPosition = 2
        worldNode.addChild(blueElementIcon)
        blueElement2Icon = ElementIcon(image: SKTexture(imageNamed:"blueElement"))
        blueElement2Icon.position = element2Position
        blueElement2Icon.zPosition = 2
        worldNode.addChild(blueElement2Icon)
        blueElement3Icon = ElementIcon(image: SKTexture(imageNamed:"blueElement"))
        blueElement3Icon.position = element3Position
        blueElement3Icon.zPosition = 2
        worldNode.addChild(blueElement3Icon)
        
        greenElementIcon = ElementIcon(image: SKTexture(imageNamed:"greenElement"))
        greenElementIcon.position = element1Position
        greenElementIcon.zPosition = 2
        worldNode.addChild(greenElementIcon)
        greenElement2Icon = ElementIcon(image: SKTexture(imageNamed:"greenElement"))
        greenElement2Icon.position = element2Position
        greenElement2Icon.zPosition = 2
        worldNode.addChild(greenElement2Icon)
        greenElement3Icon = ElementIcon(image: SKTexture(imageNamed:"greenElement"))
        greenElement3Icon.position = element3Position
        greenElement3Icon.zPosition = 2
        worldNode.addChild(greenElement3Icon)
        
        //Tutorial
        tutorialPage = SKSpriteNode(texture: SKTexture(imageNamed:"tut1"), color: SKColor.clear, size: CGSize(width: 800, height: 590))
        tutorialPage.position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.75)
        tutorialPage.zPosition = 5
        tutorialPage.alpha = 0.0
        uiNode.addChild(tutorialPage)
        
        tutorialAnim = [SKTexture]()
        for i in 2...21 {
            tutorialAnim.append(SKTexture(imageNamed:"tut"+String(i)))
        }
        
        soundButton = SKSpriteNode(texture: SKTexture(imageNamed: "SoundOn"), color: SKColor.clear, size: CGSize(width: 150, height: 150))
        soundButton.zPosition = 2
        if UIDevice.current.userInterfaceIdiom == .pad {
            soundButton.position = CGPoint(x: size.width*0.05, y: size.height*0.22)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            soundButton.position = CGPoint(x: size.width*0.05, y: playableRect.maxY*0.22)
        }
        
        musicButton = SKSpriteNode(texture: SKTexture(imageNamed:"MusicOn"), color: SKColor.clear, size: CGSize(width: 150, height: 150))
        musicButton.zPosition = 2
        if UIDevice.current.userInterfaceIdiom == .pad {
            musicButton.position = CGPoint(x: size.width*0.05, y: size.height*0.36)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            musicButton.position = CGPoint(x: size.width*0.05, y: playableRect.maxY*0.36)
        }
        
        if !GameViewController.soundEnabled {soundButton.texture = SKTexture(imageNamed:"SoundOff")}
        if !GameViewController.musicEnabled {musicButton.texture = SKTexture(imageNamed:"MusicOff")}
        uiNode.addChild(soundButton)
        uiNode.addChild(musicButton)
        
    }
    
    //Button effects
    func createElement(name:String) {
        if name == "Button1" {
            createRed()
        }
        else if name == "Button2" {
            createBlue()
        }
        else if name == "Button3" {
            createGreen()
        }
        else {print("createElement() ERROR.")}
    }
    
    func createRed() {
        //No elements on screen - Player either hasn't tapped button OR Player has invoked by pressing invokeButton
        if element1 == 0 && element2 == 0 && element3 == 0 {
            element1Name = "Red"
            element1 = 1
            redElementIcon.alpha = 1.0
            blueElementIcon.alpha = 0.0
            greenElementIcon.alpha = 0.0
        }
        else if element1 == 1 && element2 == 0 && element3 == 0 {
            //Put in slot2
            element2Name = "Red"
            element2 = 1
            redElement2Icon.alpha = 1.0
            blueElement2Icon.alpha = 0.0
            greenElement2Icon.alpha = 0.0
        }
        else if element1 == 1 && element2 == 1 && element3 == 0 {
            //Put in slot3
            element3Name = "Red"
            element3 = 1
            redElement3Icon.alpha = 1.0
            blueElement3Icon.alpha = 0.0
            greenElement3Icon.alpha = 0.0
        }
        else if element1 == 1 && element2 == 1 && element3 == 1 {
            //Move slot2 to slot1
            if element2Name == "Red" {
                element1Name = "Red"
                redElementIcon.alpha = 1.0
                blueElementIcon.alpha = 0.0
                greenElementIcon.alpha = 0.0
            }
            else if element2Name == "Blue" {
                element1Name = "Blue"
                redElementIcon.alpha = 0.0
                blueElementIcon.alpha = 1.0
                greenElementIcon.alpha = 0.0
            }
            else if element2Name == "Green" {
                element1Name = "Green"
                redElementIcon.alpha = 0.0
                blueElementIcon.alpha = 0.0
                greenElementIcon.alpha = 1.0
            }
            //Move slot3 to slot2
            if element3Name == "Red" {
                element2Name = "Red"
                redElement2Icon.alpha = 1.0
                blueElement2Icon.alpha = 0.0
                greenElement2Icon.alpha = 0.0
            }
            else if element3Name == "Blue" {
                element2Name = "Blue"
                redElement2Icon.alpha = 0.0
                blueElement2Icon.alpha = 1.0
                greenElement2Icon.alpha = 0.0
            }
            else if element3Name == "Green" {
                element2Name = "Green"
                redElement2Icon.alpha = 0.0
                blueElement2Icon.alpha = 0.0
                greenElement2Icon.alpha = 1.0
            }
            element3Name = "Red"
            element3 = 1
            redElement3Icon.alpha = 1.0
            blueElement3Icon.alpha = 0.0
            greenElement3Icon.alpha = 0.0
        }
    }
    
    func createBlue() {
        if element1 == 0 && element2 == 0 && element3 == 0 {
            element1Name = "Blue"
            element1 = 1
            redElementIcon.alpha = 0.0
            blueElementIcon.alpha = 1.0
            greenElementIcon.alpha = 0.0
        }
        else if element1 == 1 && element2 == 0 && element3 == 0 {
            //Put in slot2
            element2Name = "Blue"
            element2 = 1
            redElement2Icon.alpha = 0.0
            blueElement2Icon.alpha = 1.0
            greenElement2Icon.alpha = 0.0
        }
        else if element1 == 1 && element2 == 1 && element3 == 0 {
            //Put in slot3
            element3Name = "Blue"
            element3 = 1
            redElement3Icon.alpha = 0.0
            blueElement3Icon.alpha = 1.0
            greenElement3Icon.alpha = 0.0
        }
        else if element1 == 1 && element2 == 1 && element3 == 1 {
            //Move slot2 to slot1
            if element2Name == "Red" {
                element1Name = "Red"
                redElementIcon.alpha = 1.0
                blueElementIcon.alpha = 0.0
                greenElementIcon.alpha = 0.0
            }
            else if element2Name == "Blue" {
                element1Name = "Blue"
                redElementIcon.alpha = 0.0
                blueElementIcon.alpha = 1.0
                greenElementIcon.alpha = 0.0
            }
            else if element2Name == "Green" {
                element1Name = "Green"
                redElementIcon.alpha = 0.0
                blueElementIcon.alpha = 0.0
                greenElementIcon.alpha = 1.0
            }
            //Move slot3 to slot2
            if element3Name == "Red" {
                element2Name = "Red"
                redElement2Icon.alpha = 1.0
                blueElement2Icon.alpha = 0.0
                greenElement2Icon.alpha = 0.0
            }
            else if element3Name == "Blue" {
                element2Name = "Blue"
                redElement2Icon.alpha = 0.0
                blueElement2Icon.alpha = 1.0
                greenElement2Icon.alpha = 0.0
            }
            else if element3Name == "Green" {
                element2Name = "Green"
                redElement2Icon.alpha = 0.0
                blueElement2Icon.alpha = 0.0
                greenElement2Icon.alpha = 1.0
            }
            element3Name = "Blue"
            element3 = 1
            redElement3Icon.alpha = 0.0
            blueElement3Icon.alpha = 1.0
            greenElement3Icon.alpha = 0.0
        }
    }
    
    func createGreen() {
        if element1 == 0 && element2 == 0 && element3 == 0 {
            element1Name = "Green"
            element1 = 1
            redElementIcon.alpha = 0.0
            blueElementIcon.alpha = 0.0
            greenElementIcon.alpha = 1.0
        }
        else if element1 == 1 && element2 == 0 && element3 == 0 {
            //Put in slot2
            element2Name = "Green"
            element2 = 1
            redElement2Icon.alpha = 0.0
            blueElement2Icon.alpha = 0.0
            greenElement2Icon.alpha = 1.0
        }
        else if element1 == 1 && element2 == 1 && element3 == 0 {
            //Put in slot3
            element3Name = "Green"
            element3 = 1
            redElement3Icon.alpha = 0.0
            blueElement3Icon.alpha = 0.0
            greenElement3Icon.alpha = 1.0
        }
        else if element1 == 1 && element2 == 1 && element3 == 1 {
            //Move slot2 to slot1
            if element2Name == "Red" {
                element1Name = "Red"
                redElementIcon.alpha = 1.0
                blueElementIcon.alpha = 0.0
                greenElementIcon.alpha = 0.0
            }
            else if element2Name == "Blue" {
                element1Name = "Blue"
                redElementIcon.alpha = 0.0
                blueElementIcon.alpha = 1.0
                greenElementIcon.alpha = 0.0
            }
            else if element2Name == "Green" {
                element1Name = "Green"
                redElementIcon.alpha = 0.0
                blueElementIcon.alpha = 0.0
                greenElementIcon.alpha = 1.0
            }
            //Move slot3 to slot2
            if element3Name == "Red" {
                element2Name = "Red"
                redElement2Icon.alpha = 1.0
                blueElement2Icon.alpha = 0.0
                greenElement2Icon.alpha = 0.0
            }
            else if element3Name == "Blue" {
                element2Name = "Blue"
                redElement2Icon.alpha = 0.0
                blueElement2Icon.alpha = 1.0
                greenElement2Icon.alpha = 0.0
            }
            else if element3Name == "Green" {
                element2Name = "Green"
                redElement2Icon.alpha = 0.0
                blueElement2Icon.alpha = 0.0
                greenElement2Icon.alpha = 1.0
            }
            element3Name = "Green"
            element3 = 1
            redElement3Icon.alpha = 0.0
            blueElement3Icon.alpha = 0.0
            greenElement3Icon.alpha = 1.0
        }
    }
    
    func invoke() {
        //Destroy enemy if combination matches
        if element1Name == "Red" && element2Name == "Red" && element3Name == "Red" {
            explodeRedEnemy()
        }
        else if element1Name == "Blue" && element2Name == "Blue" && element3Name == "Blue" {
            explodeBlueEnemy()
        }
        else if element1Name == "Green" && element2Name == "Green" && element3Name == "Green" {
            explodeGreenEnemy()
        }
        else if element1Name == "Red" && element2Name == "Blue" && element3Name == "Green" {
            explodeYellowEnemy()
        }
        else if element1Name == "Red" && element2Name == "Red" && element3Name == "Blue" {
            explodePinkEnemy()
        }
        else if element1Name == "Blue" && element2Name == "Blue" && element3Name == "Green" {
            explodeFastEnemy()
        }
        else if element1Name == "Green" && element2Name == "Green" && element3Name == "Red" {
            explodeChargeEnemy()
        }
        else if element1Name == "Green" && element2Name == "Blue" && element3Name == "Green" {
            explodeInvisEnemy()
        }
        else if element1Name == "Blue" && element2Name == "Red" && element3Name == "Red" {
            explodeDarkEnemy()
        }
        else {}
        
        invokeRemoveAll()
    }
    //Reset all elements - No Colours Tapped
    func invokeRemoveAll() {
        element1Name = ""
        element1 = 0
        redElementIcon.alpha = 0.0
        blueElementIcon.alpha = 0.0
        greenElementIcon.alpha = 0.0
        
        element2Name = ""
        element2 = 0
        redElement2Icon.alpha = 0.0
        blueElement2Icon.alpha = 0.0
        greenElement2Icon.alpha = 0.0
        
        element3Name = ""
        element3 = 0
        redElement3Icon.alpha = 0.0
        blueElement3Icon.alpha = 0.0
        greenElement3Icon.alpha = 0.0
    }
    
    //SPAWN
    
    //First Enemy - Starts the game when enemy is destroyed
    func spawnInitialRedEnemy() {
        let monster = RedEnemy()
        initialEnemy = monster
        
        //Spell Combination - Destroy enemy by tapping on buttons in this combination
        let spellCombo = SKSpriteNode(texture: SKTexture(imageNamed:"1"), color: SKColor.red, size: CGSize(width: 220, height: 47))
        spellCombo.zPosition = 0
        spellCombo.position = CGPoint(x: 0, y: size.height*0.0818)
        monster.addChild(spellCombo)
        
        monster.name = "InitialRedEnemy"
        monster.position = CGPoint(x: size.width, y: playableRect.maxY*0.8)
        monster.zPosition = 1
        worldNode.addChild(monster)
        
        //Move enemy to top right of screen so player can see it
        monster.run(SKAction.move(to: CGPoint(x: size.width*0.9, y: monster.position.y), duration: 3))
        //ANIMATION
        monster.run(SKAction.repeatForever(SKAction.animate(with: redEnemyAnimation, timePerFrame: 0.2)))
        
        //Show Tutorial
        tutorialPage.position.y = CGFloat(size.height*1.5)
        tutorialPage.removeAllActions()
        tutorialPage.alpha = 1.0
        tutorialPage.run(SKAction.moveTo(y: playableRect.maxY*0.75, duration: 0.5))
        showTutorial()
    }
    func spawnBasicEnemy(colour:String) {
        guard colour == "Red" || colour == "Blue" || colour == "Green" || colour == "Yellow" || colour == "Pink" else {print("spawnBasicEnemy: Wrong parameter given.");return}
        
        var monster = Enemy(SPD: 100)
        
        //Random Y Position Number
        let randomNumber = GKRandomDistribution(lowestValue: Int(playableRect.maxY*0.45), highestValue: Int(playableRect.maxY*0.85))
        let randomYPosition = CGFloat(randomNumber.nextInt())
        
        //Spell Combination
        let spellCombo = SKSpriteNode(texture: SKTexture(imageNamed:"1"), color: SKColor.red, size: CGSize(width: 225, height: 50))
        spellCombo.zPosition = 2
        spellCombo.position = CGPoint(x: 0, y: size.height*0.07)
        
        if colour == "Red" {
            monster = RedEnemy()
            monster.name = "RedEnemy"
            spellCombo.texture = SKTexture(imageNamed: "1")
        }
        else if colour == "Blue" {
            monster = BlueEnemy()
            monster.name = "BlueEnemy"
            spellCombo.texture = SKTexture(imageNamed: "2")
        }
        else if colour == "Green" {
            monster = GreenEnemy()
            monster.name = "GreenEnemy"
            spellCombo.texture = SKTexture(imageNamed: "3")
        }
        else if colour == "Yellow" {
            monster = YellowEnemy()
            monster.name = "YellowEnemy"
            spellCombo.texture = SKTexture(imageNamed: "4")
        }
        else if colour == "Pink" {
            monster = PinkEnemy()
            monster.name = "PinkEnemy"
            spellCombo.texture = SKTexture(imageNamed: "5")
        }
        
        //Physics Body to damage player
        monster.physicsBody = SKPhysicsBody(texture: monster.texture!, size: (monster.size))
        monster.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        monster.physicsBody?.collisionBitMask = PhysicsCategory.none
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.goal
        monster.zPosition = 0
        monster.position = CGPoint(x: size.width, y: randomYPosition)
        
        worldNode.addChild(monster)
        monster.addChild(spellCombo)
        
        monster.run(SKAction.move(to: CGPoint(x: -(size.width*0.05), y: monster.position.y), duration: monster.speedOfMonster))
        
        //ANIMATION
        if colour == "Red" {monster.run(SKAction.repeatForever(SKAction.animate(with: redEnemyAnimation, timePerFrame: 0.1)))}
        else if colour == "Blue" {monster.run(SKAction.repeatForever(SKAction.animate(with: blueEnemyAnimation, timePerFrame: 0.1)))}
        else if colour == "Green" {monster.run(SKAction.repeatForever(SKAction.animate(with: greenEnemyAnimation, timePerFrame: 0.1)))}
        else if colour == "Yellow" {monster.run(SKAction.repeatForever(SKAction.animate(with: yellowEnemyAnimation, timePerFrame: 0.1)))}
        else if colour == "Pink" {monster.run(SKAction.repeatForever(SKAction.animate(with: pinkEnemyAnimation, timePerFrame: 0.1)))}
    }
    func spawnComplexEnemy(colour:String) {
        guard colour == "Fast" || colour == "Charge" || colour == "Invis" || colour == "Dark" else {print("spawnComplexEnemy: Wrong parameter given.");return}
        
        var monster = Enemy(SPD: 100)
        
        //Random Y Position Number
        let randomNumber = GKRandomDistribution(lowestValue: Int(playableRect.maxY*0.45), highestValue: Int(playableRect.maxY*0.85))
        let randomYPosition = CGFloat(randomNumber.nextInt())
        
        //Spell Combination
        let spellCombo = SKSpriteNode(texture: SKTexture(imageNamed:"1"), color: SKColor.red, size: CGSize(width: 225, height: 50))
        spellCombo.zPosition = 2
        spellCombo.position = CGPoint(x: 0, y: size.height*0.09)
        
        if colour == "Fast" {
            monster = FastEnemy()
            monster.name = "FastEnemy"
            spellCombo.texture = SKTexture(imageNamed: "6")
        }
        else if colour == "Charge" {
            monster = ChargeEnemy()
            monster.name = "ChargeEnemy"
            spellCombo.texture = SKTexture(imageNamed: "7")
        }
        else if colour == "Invis" {
            monster = InvisEnemy()
            monster.name = "InvisEnemy"
            spellCombo.texture = SKTexture(imageNamed: "8")
        }
        else if colour == "Dark" {
            monster = DarknessEnemy()
            monster.name = "DarkEnemy"
            spellCombo.texture = SKTexture(imageNamed: "9")
        }
        
        //Physics Body to damage player
        monster.physicsBody = SKPhysicsBody(texture: monster.texture!, size: (monster.size))
        monster.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        monster.physicsBody?.collisionBitMask = PhysicsCategory.none
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.goal
        monster.zPosition = 0
        monster.position = CGPoint(x: size.width, y: randomYPosition)
        
        worldNode.addChild(monster)
        monster.addChild(spellCombo)
        
        monster.run(SKAction.move(to: CGPoint(x: -(size.width*0.05), y: monster.position.y), duration: monster.speedOfMonster),withKey:"Move")
        
        //MECHANICS
        
        //Charge Mechanic
        if colour == "Charge" {
            monster.removeAction(forKey: "Move")
            monster.run(SKAction.move(to: CGPoint(x: size.width*0.8, y: monster.position.y), duration: monster.speedOfMonster), completion: {[unowned self] in
                //Flap Anim for 10s
                monster.run(SKAction.wait(forDuration: 5), completion: {
                    monster.removeAction(forKey: "ChargeEnemyMove")})
                //Charge at Goal after 10s
                monster.run(SKAction.wait(forDuration: 15), completion:{[unowned self] in
                    monster.run(SKAction.move(to: CGPoint(x: -(self.size.width*0.05), y: monster.position.y), duration: 3), withKey: "ChargeEnemyMove")
                    monster.run(SKAction.repeatForever(SKAction.animate(with: self.chargeEnemyAnimation, timePerFrame: 0.03)))})
            })
        }
        //Invis Mechanic
        else if colour == "Invis" {
            //Random invis number
            let randomInvisNumber = GKRandomDistribution(lowestValue: 1, highestValue: 12)
            let randomInvisX = randomInvisNumber.nextInt()
            let invisOutTime = 7 + Int(randomInvisX)
            
            monster.run(SKAction.wait(forDuration: TimeInterval(randomInvisX)), completion: {
                monster.run(SKAction.fadeOut(withDuration: 2))})
            monster.run(SKAction.wait(forDuration: TimeInterval(invisOutTime)), completion: {
                monster.run(SKAction.fadeIn(withDuration: 2))})
            //Hide the spell combination as well
            spellCombo.run(SKAction.wait(forDuration: TimeInterval(randomInvisX)),completion:{
                spellCombo.run(SKAction.fadeOut(withDuration: 2))})
            spellCombo.run(SKAction.wait(forDuration: TimeInterval(invisOutTime)),completion:{
                spellCombo.run(SKAction.fadeIn(withDuration: 2))})
        }
        //Darkness Mechanic
        else if colour == "Dark" {
            //Random darkness number
            let randomDarknessNumber = GKRandomDistribution(lowestValue: 1, highestValue: 10)
            let randomDarknessX = randomDarknessNumber.nextInt()
            let darknessOutTime = 2 + Int(randomDarknessX)
            
            monster.run(SKAction.wait(forDuration: TimeInterval(randomDarknessX)), completion: {[unowned self] in
                self.darknessScreen.run(SKAction.fadeIn(withDuration: 1))})
            self.run(SKAction.wait(forDuration: TimeInterval(darknessOutTime)), completion: {[unowned self] in
                self.darknessScreen.run(SKAction.fadeOut(withDuration: 1))})
        }
        
        //ANIMATION
        if colour == "Fast" {monster.run(SKAction.repeatForever(SKAction.animate(with: fastEnemyAnimation, timePerFrame: 0.08)))}
        else if colour == "Charge" {monster.run(SKAction.repeatForever(SKAction.animate(with: chargeEnemyAnimation, timePerFrame: 0.1)))}
        else if colour == "Invis" {monster.run(SKAction.repeatForever(SKAction.animate(with: invisEnemyAnimation, timePerFrame: 0.1)))}
        else if colour == "Dark" {monster.run(SKAction.repeatForever(SKAction.animate(with: darknessEnemyAnimation, timePerFrame: 0.1)))}
    }
    
    //DESTROY
    func explodeRedEnemy() {
        for node in worldNode.children {
            if let child = node as? Enemy {
                score += 1
                if child.name == "InitialRedEnemy" {
                    child.removeAllActions()
                    //TODO: uiNode.run(redExplode1Fx)
                    
                    particleAnimation(particleFileName: "RedEnemy", node: child)
                    
                    child.removeFromParent()
                    startGame()
                    break;
                }
                else if child.name == "RedEnemy" {
                    showCoin(position: child.position)
                    particleAnimation(particleFileName: "RedEnemy", node: child)
                    child.removeAllActions()
                    child.removeFromParent()
                    break;
                }
            }
        }
    }
    func explodeBlueEnemy() {
        for node in worldNode.children {
            if let child = node as? Enemy {
                score += 1
                if child.name == "BlueEnemy" {
                    showCoin(position: child.position)
                    particleAnimation(particleFileName: "BlueEnemy", node: child)
                    child.removeAllActions()
                    child.removeFromParent()
                    break;
                }
            }
        }
    }
    func explodeGreenEnemy() {
        for node in worldNode.children {
            if let child = node as? Enemy {
                score += 1
                if child.name == "GreenEnemy" {
                    showCoin(position: child.position)
                    particleAnimation(particleFileName: "GreenEnemy", node: child)
                    child.removeAllActions()
                    child.removeFromParent()
                    break;
                }
            }
        }
    }
    func explodeYellowEnemy() {
        for node in worldNode.children {
            if let child = node as? Enemy {
                score += 1
                if child.name == "YellowEnemy" {
                    showCoin(position: child.position)
                    particleAnimation(particleFileName: "YellowEnemy", node: child)
                    child.removeAllActions()
                    child.removeFromParent()
                    break;
                }
            }
        }
    }
    func explodePinkEnemy() {
        for node in worldNode.children {
            if let child = node as? Enemy {
                score += 1
                if child.name == "PinkEnemy" {
                    showCoin(position: child.position)
                    particleAnimation(particleFileName: "PinkEnemy", node: child)
                    child.removeAllActions()
                    child.removeFromParent()
                    break;
                }
            }
        }
    }
    func explodeFastEnemy() {
        for node in worldNode.children {
            if let child = node as? Enemy {
                score += 1
                if child.name == "FastEnemy" {
                    showCoin(position: child.position)
                    particleAnimation(particleFileName: "FastEnemy", node: child)
                    child.removeAllActions()
                    child.removeFromParent()
                    break;
                }
            }
        }
    }
    func explodeChargeEnemy() {
        for node in worldNode.children {
            if let child = node as? Enemy {
                score += 1
                if child.name == "ChargeEnemy" {
                    showCoin(position: child.position)
                    particleAnimation(particleFileName: "ChargeEnemy", node: child)
                    child.removeAllActions()
                    child.removeFromParent()
                    break;
                }
            }
        }
    }
    func explodeInvisEnemy() {
        for node in worldNode.children {
            if let child = node as? Enemy {
                score += 1
                if child.name == "InvisEnemy" {
                    showCoin(position: child.position)
                    particleAnimation(particleFileName: "InvisEnemy", node: child)
                    child.removeAllActions()
                    child.removeFromParent()
                    break;
                }
            }
        }
    }
    func explodeDarkEnemy() {
        for node in worldNode.children {
            if let child = node as? Enemy {
                score += 1
                if child.name == "DarkEnemy" {
                    showCoin(position: child.position)
                    particleAnimation(particleFileName: "DarkEnemy", node: child)
                    child.removeAllActions()
                    child.removeFromParent()
                    break;
                }
            }
        }
    }
    
    func spawnEnemy(randomNumber:Int) {
        guard healthPoints > 0 else {return}
        let random = GKRandomDistribution(lowestValue: 1, highestValue: 6)
        let randomNextNumber = random.nextInt()
        
        //Initial gameWaitTime = 4
        self.run(SKAction.wait(forDuration: TimeInterval(self.gameWaitTime)),completion: {[unowned self] in
            guard self.healthPoints > 0 else {return}
            
            if self.score < 2 {
                self.spawnBasicEnemy(colour: "Red")
            }
            else if self.score < 5 {
                if randomNumber <= 1 {
                    self.spawnBasicEnemy(colour: "Red")
                }
                else if randomNumber <= 4 {
                    self.spawnBasicEnemy(colour: "Blue")
                }
                else if randomNumber > 4 {
                    self.spawnBasicEnemy(colour: "Green")
                }
            }
            else if self.score < 9 {
                if randomNumber == 1 {
                    self.spawnBasicEnemy(colour: "Blue")
                }
                else if randomNumber <= 4 {
                    self.spawnBasicEnemy(colour: "Yellow")
                }
                else if randomNumber > 4 {
                    self.spawnBasicEnemy(colour: "Pink")
                }
            }
            //Introduce Fast enemy
            else if self.score < 14 {
                if randomNumber == 1 {self.spawnBasicEnemy(colour: "Pink")}
                else if randomNumber == 2 {self.spawnBasicEnemy(colour: "Yellow")}
                else if randomNumber > 2 {
                    self.spawnComplexEnemy(colour: "Fast")
                }
            }
            //Introduce Charge enemy
            else if self.score < 18 {
                if randomNumber == 1 {self.spawnBasicEnemy(colour: "Blue")}
                else if randomNumber == 2 {self.spawnBasicEnemy(colour: "Green")}
                else if randomNumber > 2 {
                    self.spawnComplexEnemy(colour: "Charge")
                }
            }
            //Introduce Invis enemy
            else if self.score < 22 {
                if randomNumber == 1 {self.spawnBasicEnemy(colour: "Pink")}
                else if randomNumber == 2 {self.spawnBasicEnemy(colour: "Yellow")}
                else if randomNumber > 2 {
                    self.spawnComplexEnemy(colour: "Invis")
                }
            }
            //Introduce Darkness enemy
            else if self.score < 27 {
                if randomNumber == 1 {self.spawnBasicEnemy(colour: "Red")}
                else if randomNumber == 2 {self.spawnBasicEnemy(colour: "Blue")}
                else if randomNumber > 2 {
                    self.spawnComplexEnemy(colour: "Dark")
                }
            }
            //Spawn 2 enemies at once
            else if self.score < 31 {
                if randomNumber == 1 {self.spawnBasicEnemy(colour: "Red");self.spawnComplexEnemy(colour: "Dark")}
                else if randomNumber == 2 {self.spawnBasicEnemy(colour: "Blue");self.spawnComplexEnemy(colour: "Invis")}
                else if randomNumber == 3 {self.spawnBasicEnemy(colour: "Green");self.spawnComplexEnemy(colour: "Fast")}
                else if randomNumber == 4 {self.spawnBasicEnemy(colour: "Yellow");self.spawnComplexEnemy(colour: "Charge")}
                else if randomNumber == 5 {self.spawnBasicEnemy(colour: "Pink");self.spawnComplexEnemy(colour: "Invis")}
                else if randomNumber == 6 {self.spawnBasicEnemy(colour: "Blue");self.spawnComplexEnemy(colour: "Invis")}
            }
            //Increase spawn frequency (reduce GameWaitTime)
            else if self.score < 35 {
                if randomNumber == 1 {self.spawnBasicEnemy(colour: "Red");self.spawnComplexEnemy(colour: "Dark")}
                else if randomNumber == 2 {self.spawnBasicEnemy(colour: "Blue");self.spawnComplexEnemy(colour: "Invis")}
                else if randomNumber == 3 {self.spawnBasicEnemy(colour: "Green");self.spawnComplexEnemy(colour: "Fast")}
                else if randomNumber == 4 {self.spawnBasicEnemy(colour: "Yellow");self.spawnComplexEnemy(colour: "Charge")}
                else if randomNumber == 5 {self.spawnBasicEnemy(colour: "Pink");self.spawnComplexEnemy(colour: "Invis")}
                else if randomNumber == 6 {self.spawnBasicEnemy(colour: "Blue");self.spawnComplexEnemy(colour: "Invis")}
                self.gameWaitTime = 3
            }
            //Higher frequency
            else if self.score < 52 {
                if randomNumber == 1 {self.spawnBasicEnemy(colour: "Red");self.spawnComplexEnemy(colour: "Dark");self.spawnBasicEnemy(colour: "Red")}
                else if randomNumber == 2 {self.spawnBasicEnemy(colour: "Blue");self.spawnComplexEnemy(colour: "Invis");self.spawnBasicEnemy(colour: "Green");}
                else if randomNumber == 3 {self.spawnBasicEnemy(colour: "Green");self.spawnComplexEnemy(colour: "Fast");self.spawnBasicEnemy(colour: "Blue")}
                else if randomNumber == 4 {self.spawnBasicEnemy(colour: "Yellow");self.spawnComplexEnemy(colour: "Charge");self.spawnBasicEnemy(colour: "Yellow")}
                else if randomNumber == 5 {self.spawnBasicEnemy(colour: "Pink");self.spawnComplexEnemy(colour: "Invis");self.spawnBasicEnemy(colour: "Pink")}
                else if randomNumber == 6 {self.spawnBasicEnemy(colour: "Blue");self.spawnComplexEnemy(colour: "Invis");self.spawnBasicEnemy(colour: "Pink")}
            }
            //Increased Frequency
            else if self.score > 52 {
                if randomNumber == 1 {self.spawnBasicEnemy(colour: "Red");self.spawnComplexEnemy(colour: "Dark");self.spawnBasicEnemy(colour: "Pink");self.spawnComplexEnemy(colour: "Fast")}
                else if randomNumber == 2 {self.spawnBasicEnemy(colour: "Blue");self.spawnComplexEnemy(colour: "Invis");self.spawnBasicEnemy(colour: "Green");self.spawnComplexEnemy(colour: "Invis")}
                else if randomNumber == 3 {self.spawnBasicEnemy(colour: "Green");self.spawnComplexEnemy(colour: "Fast");self.spawnBasicEnemy(colour: "Blue");self.spawnComplexEnemy(colour: "Fast")}
                else if randomNumber == 4 {self.spawnBasicEnemy(colour: "Yellow");self.spawnComplexEnemy(colour: "Charge");self.spawnBasicEnemy(colour: "Yellow");self.spawnComplexEnemy(colour: "Dark")}
                else if randomNumber == 5 {self.spawnBasicEnemy(colour: "Pink");self.spawnComplexEnemy(colour: "Invis");self.spawnBasicEnemy(colour: "Pink");self.spawnComplexEnemy(colour: "Charge")}
                else if randomNumber == 6 {self.spawnBasicEnemy(colour: "Blue");self.spawnComplexEnemy(colour: "Invis");self.spawnBasicEnemy(colour: "Pink");self.spawnComplexEnemy(colour: "Invis")}
                self.gameWaitTime = 2
            }
            
            self.spawnEnemy(randomNumber: randomNextNumber)
        })
    }
    
    func createEnemyAnimations() {
        redEnemyAnimation = [SKTexture]()
        for i in 1...2 {
            redEnemyAnimation.append(SKTexture(imageNamed:"Red"+String(i)))
        }
        blueEnemyAnimation = [SKTexture]()
        for i in 1...4 {
            blueEnemyAnimation.append(SKTexture(imageNamed:"Blue"+String(i)))
        }
        greenEnemyAnimation = [SKTexture]()
        for i in 1...4 {
            greenEnemyAnimation.append(SKTexture(imageNamed:"Green"+String(i)))
        }
        yellowEnemyAnimation = [SKTexture]()
        for i in 1...4 {
            yellowEnemyAnimation.append(SKTexture(imageNamed:"Yellow"+String(i)))
        }
        pinkEnemyAnimation = [SKTexture]()
        for i in 1...4 {
            pinkEnemyAnimation.append(SKTexture(imageNamed:"Pink"+String(i)))
        }
        fastEnemyAnimation = [SKTexture]()
        for i in 1...6 {
            fastEnemyAnimation.append(SKTexture(imageNamed:"Speed"+String(i)))
        }
        chargeEnemyAnimation = [SKTexture]()
        for i in 1...4 {
            chargeEnemyAnimation.append(SKTexture(imageNamed:"Charge"+String(i)))
        }
        invisEnemyAnimation = [SKTexture]()
        for i in 1...8 {
            invisEnemyAnimation.append(SKTexture(imageNamed:"Invis"+String(i)))
        }
        darknessEnemyAnimation = [SKTexture]()
        for i in 1...2 {
            darknessEnemyAnimation.append(SKTexture(imageNamed:"Dark"+String(i)))
        }
        
        //Coin animation
        coinAnimation = [SKTexture]()
        for i in 1...6 {
            coinAnimation.append(SKTexture(imageNamed:"CoinRotate"+String(i)))
        }
    }
    
    //Tutorial
    func showTutorial() {
        tutorialPage.run(SKAction.fadeAlpha(to: 1.0, duration: 2.0),completion:{[unowned self] in
            self.tutorialPage.run(SKAction.repeatForever(SKAction.animate(with: self.tutorialAnim, timePerFrame: 0.20)),withKey:"TutorialAnim")
        })
    }
    
    //Shop
    func createShop() {
        shopBackground = SKSpriteNode(texture: SKTexture(imageNamed:"ShopBg"), color: SKColor.clear, size: CGSize(width: 875, height: 1050))
        shopBackground.zPosition = 10
        shopBackground.position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.57)
        shopBackground.alpha = 0.0
        uiNode.addChild(shopBackground)
        
        shopBuyButton1 = SKSpriteNode(texture: SKTexture(imageNamed: "BuyButton"), color: SKColor.clear, size: CGSize(width: 130, height: 130))
        shopBuyButton1.zPosition = 11
        shopBuyButton1.position = CGPoint(x: size.width*0.615, y: playableRect.maxY*0.71)
        shopBuyButton1.alpha = 0.0
        uiNode.addChild(shopBuyButton1)
        
        shopBuyButton2 = SKSpriteNode(texture: SKTexture(imageNamed: "BuyButton"), color: SKColor.clear, size: CGSize(width: 130, height: 130))
        shopBuyButton2.zPosition = 11
        shopBuyButton2.position = CGPoint(x: size.width*0.615, y: playableRect.maxY*0.539)
        shopBuyButton2.alpha = 0.0
        uiNode.addChild(shopBuyButton2)
        
        crossButton = SKSpriteNode(texture: SKTexture(imageNamed:"CrossButton"), color: SKColor.clear, size: CGSize(width: 150, height: 150))
        crossButton.zPosition = 11
        crossButton.position = CGPoint(x: size.width*0.69, y: playableRect.maxY*0.87)
        crossButton.alpha = 0.0
        uiNode.addChild(crossButton)
        
        shopCoinsLabel = SKLabelNode()
        shopCoinsLabel.position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.23)
        shopCoinsLabel.zPosition = 11
        shopCoinsLabel.text = String("\(GameViewController.coins)")
        shopCoinsLabel.fontName = "Palatino-Bold"
        shopCoinsLabel.fontColor = SKColor.white
        shopCoinsLabel.fontSize = 70
        shopCoinsLabel.verticalAlignmentMode = .center
        shopCoinsLabel.horizontalAlignmentMode = .center
        shopCoinsLabel.alpha = 0.0
        uiNode.addChild(shopCoinsLabel)
    }
    func showShop() {
        hideEverything(excludeButtons: false)
        if GameViewController.coins >= 50 {shopBuyButton1?.texture = SKTexture(imageNamed: "BuyButton");shopBuyButton2?.texture = SKTexture(imageNamed: "BuyButton")}
        else {shopBuyButton1?.texture = SKTexture(imageNamed: "BuyCant");shopBuyButton2?.texture = SKTexture(imageNamed: "BuyCant")}
        worldNode.run(SKAction.wait(forDuration: 0.5),completion:{[unowned self] in
            self.shopBackground.position.y = CGFloat(self.playableRect.maxY*0.57)
            self.shopBackground.run(SKAction.fadeIn(withDuration: 0.5))
            self.shopBuyButton1.position.y = CGFloat(self.playableRect.maxY*0.71)
            self.shopBuyButton1.run(SKAction.fadeIn(withDuration: 0.5))
            self.shopBuyButton2.position.y = CGFloat(self.playableRect.maxY*0.539)
            self.shopBuyButton2.run(SKAction.fadeIn(withDuration: 0.5))
            self.crossButton.position.y = CGFloat(self.playableRect.maxY*0.87)
            self.crossButton.run(SKAction.fadeIn(withDuration: 0.5))
            self.shopCoinsLabel.position.y = CGFloat(self.playableRect.maxY*0.23)
            self.shopCoinsLabel.text = "\(GameViewController.coins)"
            self.shopCoinsLabel.run(SKAction.fadeIn(withDuration: 0.5))
        })
    }
    func hideShop() {
        self.shopBackground.run(SKAction.fadeOut(withDuration: 0.2),completion:{[unowned self] in self.shopBackground.position.y = CGFloat(self.playableRect.maxY*0.57)})
        self.shopBuyButton1.run(SKAction.fadeOut(withDuration: 0.2),completion:{[unowned self] in self.shopBuyButton1.position.y = CGFloat(self.playableRect.maxY*0.57)})
        self.shopBuyButton2.run(SKAction.fadeOut(withDuration: 0.2),completion:{[unowned self] in self.shopBuyButton2.position.y = CGFloat(self.playableRect.maxY*0.57)})
        self.crossButton.run(SKAction.fadeOut(withDuration: 0.2),completion:{[unowned self] in self.crossButton.position.y = CGFloat(self.playableRect.maxY*0.57)})
        self.shopCoinsLabel.run(SKAction.fadeOut(withDuration: 0.2),completion:{[unowned self] in self.showEverything()})
    }
    func buyItem(cost:Int, itemNumber:Int) {
        if GameViewController.coins >= cost {
            if itemNumber == 1 {GameViewController.coins-=50; GameViewController.amountOfItem1+=1}
            else if itemNumber == 2 {GameViewController.coins-=50; GameViewController.amountOfItem2+=1}
            //Image
            if GameViewController.coins >= 50 {shopBuyButton1?.texture = SKTexture(imageNamed: "BuyButton");shopBuyButton2?.texture = SKTexture(imageNamed: "BuyButton")}
            else {shopBuyButton1?.texture = SKTexture(imageNamed: "BuyCant");shopBuyButton2?.texture = SKTexture(imageNamed: "BuyCant")}
            
            //TODO: Play soundFX file
            //TODO: -Money animation
            
            //Save number of items
            if let controller = self.view?.window?.rootViewController as? GameViewController {
                controller.save()
            }
            
            //Update labels
            coinsLabel.text = "\(GameViewController.coins)"
            shopCoinsLabel.text = "\(GameViewController.coins)"
            
            //Save
            if let controller = self.view?.window?.rootViewController as? GameViewController {
                controller.save()
            }
        }
        else {/*TODO: ERROR Sound*/}
    }
    
    //Hide everything (Shop/Leader button tapped OR Starting game)
    func hideEverything(excludeButtons: Bool) {
        //Top Elements
        highScoreLabel.alpha = 1.0
        highScoreLabel.removeAllActions()
        highScoreLabel.run(SKAction.moveTo(y: size.height*1.5, duration: 0.5))
        tutorialPage.removeAllActions()
        tutorialPage.alpha = 1.0
        tutorialPage.run(SKAction.moveTo(y: size.height*1.5, duration: 0.5))
        
        //Buttons
        invokeRemoveAll()
        //Check to see if game is starting
        if !excludeButtons {
            button1.removeAllActions()
            button1.alpha = 1.0
            button1.run(SKAction.moveTo(y: -size.height*0.37, duration: 0.5))
            button2.removeAllActions()
            button2.alpha = 1.0
            button2.run(SKAction.moveTo(y: -size.height*0.37, duration: 0.5))
            button3.removeAllActions()
            button3.alpha = 1.0
            button3.run(SKAction.moveTo(y: -size.height*0.37, duration: 0.5))
            invokeButton.removeAllActions()
            invokeButton.alpha = 1.0
            invokeButton.run(SKAction.moveTo(y: -size.height*0.53, duration: 0.5))
            //Hearts
            health1.run(SKAction.moveTo(y: size.height*1.5, duration: 0.5))
            health2.run(SKAction.moveTo(y: size.height*1.5, duration: 0.5))
            health3.run(SKAction.moveTo(y: size.height*1.5, duration: 0.5))
        }
        //Left elements
        coinsLabel.alpha = 1.0
        coinsLabel.run(SKAction.moveTo(x: -size.width*0.4, duration: 0.5))
        coinsIcon.alpha = 1.0
        coinsIcon.run(SKAction.moveTo(x: -size.width*0.4, duration: 0.5))
        soundButton.alpha = 1.0
        soundButton.run(SKAction.moveTo(x: -size.width*0.4, duration: 0.5))
        musicButton.alpha = 1.0
        musicButton.run(SKAction.moveTo(x: -size.width*0.4, duration: 0.5))
        
        //Right elements
        initialEnemy?.run(SKAction.fadeOut(withDuration: 0.5))
        shopButton.removeAllActions()
        shopButton.alpha = 1.0
        shopButton.run(SKAction.moveTo(y: -size.height*1.4, duration: 0.5))
        leaderboardButton.removeAllActions()
        leaderboardButton.alpha = 1.0
        leaderboardButton.run(SKAction.moveTo(y: -size.height*1.4, duration: 0.5))
    }
    func showEverything() {
        //Top Elements
        highScoreLabel?.alpha = 1.0
        highScoreLabel?.removeAllActions()
        if UIDevice.current.userInterfaceIdiom == .pad {
            highScoreLabel?.run(SKAction.moveTo(y: size.height*0.93, duration: 0.5))
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            highScoreLabel?.run(SKAction.moveTo(y: playableRect.maxY*0.93, duration: 0.5))
        }
        tutorialPage.removeAllActions()
        tutorialPage.alpha = 1.0
        tutorialPage.run(SKAction.moveTo(y: playableRect.maxY*0.75, duration: 0.5))
        showTutorial()
        
        //Buttons
        invokeRemoveAll()
        button1.removeAllActions()
        button1.alpha = 1.0
        button1.run(SKAction.moveTo(y: playableRect.maxY*0.38, duration: 0.5))
        button2.removeAllActions()
        button2.alpha = 1.0
        button2.run(SKAction.moveTo(y: playableRect.maxY*0.38, duration: 0.5))
        button3.removeAllActions()
        button3.alpha = 1.0
        button3.run(SKAction.moveTo(y: playableRect.maxY*0.38, duration: 0.5))
        invokeButton.removeAllActions()
        invokeButton.alpha = 1.0
        invokeButton.run(SKAction.moveTo(y: playableRect.maxY*0.22, duration: 0.5))
        //Hearts
        if UIDevice.current.userInterfaceIdiom == .pad {
            health1.run(SKAction.moveTo(y: size.height*0.93, duration: 0.5))
            health2.run(SKAction.moveTo(y: size.height*0.93, duration: 0.5))
            health3.run(SKAction.moveTo(y: size.height*0.93, duration: 0.5))
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            health1.run(SKAction.moveTo(y: playableRect.maxY*0.93, duration: 0.5))
            health2.run(SKAction.moveTo(y: playableRect.maxY*0.93, duration: 0.5))
            health3.run(SKAction.moveTo(y: playableRect.maxY*0.93, duration: 0.5))
        }
        
        //Left elements
        coinsLabel.alpha = 1.0
        coinsLabel.run(SKAction.moveTo(x: size.width*0.072, duration: 0.5))
        coinsIcon.alpha = 1.0
        coinsIcon.run(SKAction.moveTo(x: size.width*0.04, duration: 0.5))
        soundButton.alpha = 1.0
        soundButton.run(SKAction.moveTo(x: size.width*0.05, duration: 0.5))
        musicButton.alpha = 1.0
        musicButton.run(SKAction.moveTo(x: size.width*0.05, duration: 0.5))
        
        //Right elements
        initialEnemy.run(SKAction.fadeIn(withDuration: 1.0))
        shopButton.removeAllActions()
        shopButton.alpha = 1.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            shopButton.run(SKAction.moveTo(y: size.height*0.22, duration: 0.5))
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            shopButton.run(SKAction.moveTo(y: playableRect.maxY*0.22, duration: 0.5))
        }
        leaderboardButton.removeAllActions()
        leaderboardButton.alpha = 1.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            leaderboardButton.run(SKAction.moveTo(y: size.height*0.36, duration: 0.5))
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            leaderboardButton.run(SKAction.moveTo(y: playableRect.maxY*0.36, duration: 0.5))
        }
        
        self.goal.physicsBody?.categoryBitMask = PhysicsCategory.goal
        
    }
    
    //SOUND FX + MUSIC TOGGLE
    func toggleSoundFx() {
        if GameViewController.soundEnabled {GameViewController.soundEnabled = false
            soundButton.texture = SKTexture(imageNamed:"SoundOff")
        }
        else if !GameViewController.soundEnabled {GameViewController.soundEnabled = true
            soundButton.texture = SKTexture(imageNamed:"SoundOn")
        }
        //Save settings
        if let controller = self.view?.window?.rootViewController as? GameViewController {
            controller.save()
        }
    }
    //TODO:
    func toggleMusic() {
        if GameViewController.musicEnabled {
            GameViewController.musicEnabled = false
            musicButton.texture = SKTexture(imageNamed:"MusicOff")
        }
        else if !GameViewController.musicEnabled {
            GameViewController.musicEnabled = true
            musicButton.texture = SKTexture(imageNamed:"MusicOn")
        }
        //Save settings
        if let controller = self.view?.window?.rootViewController as? GameViewController {
            controller.save()
        }
    }
    
    func startGame() {
        hideEverything(excludeButtons: true)
        scoreLabel.run(SKAction.fadeIn(withDuration: 0.5))
        showItems()
        
        spawnEnemy(randomNumber: 1)
    }
    
    //ITEMS
    func createItems() {
        //Items
        item1 = SKSpriteNode(texture: SKTexture(imageNamed: "health_potion"))
        item1.zPosition = 3
        if UIDevice.current.userInterfaceIdiom == .pad {
            item1.position = CGPoint(x: size.width*0.80, y: size.height*0.23)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            item1.position = CGPoint(x: size.width*0.80, y: playableRect.maxY*0.23)
        }
        item1.position.y = CGFloat(-size.height*0.37)
        item1.size = CGSize(width: 160, height: 172)
        worldNode.addChild(item1)
        
        item1Number = SKLabelNode()
        item1Number.zPosition = 4
        item1Number.text = "\(GameViewController.amountOfItem1)"
        item1Number.fontName = "AmericanTypewriter-Bold"
        item1Number.fontColor = SKColor.black
        item1Number.fontSize = 95
        item1Number.verticalAlignmentMode = .center
        item1Number.horizontalAlignmentMode = .center
        if UIDevice.current.userInterfaceIdiom == .pad {
            item1Number.position = CGPoint(x: size.width*0.77, y: size.height*0.20)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            item1Number.position = CGPoint(x: size.width*0.77, y: playableRect.maxY*0.20)
        }
        item1Number.position.y = CGFloat(-size.height*0.37)
        worldNode.addChild(item1Number)
        
        item2 = SKSpriteNode(texture: SKTexture(imageNamed: "mana_potion"))
        item2.zPosition = 3
        if UIDevice.current.userInterfaceIdiom == .pad {
            item2.position = CGPoint(x: size.width*0.93, y: size.height*0.23)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            item2.position = CGPoint(x: size.width*0.93, y: playableRect.maxY*0.23)
        }
        item2.size = CGSize(width: 160, height: 172)
        item2.position.y = CGFloat(-size.height*0.37)
        worldNode.addChild(item2)
        
        item2Number = SKLabelNode()
        item2Number.zPosition = 4
        item2Number.text = "\(GameViewController.amountOfItem2)"
        item2Number.fontName = "AmericanTypewriter-Bold"
        item2Number.fontColor = SKColor.black
        item2Number.fontSize = 95
        item2Number.verticalAlignmentMode = .center
        item2Number.horizontalAlignmentMode = .center
        if UIDevice.current.userInterfaceIdiom == .pad {
            item2Number.position = CGPoint(x: size.width*0.905, y: size.height*0.20)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            item2Number.position = CGPoint(x: size.width*0.905, y: playableRect.maxY*0.20)
        }
        item2Number.position.y = CGFloat(-size.height*0.37)
        worldNode.addChild(item2Number)
    }
    func showItems() {
        item1.alpha = 1.0
        item1Number.alpha = 1.0
        item2.alpha = 1.0
        item2Number.alpha = 1.0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            item1.run(SKAction.moveTo(y: size.height*0.23, duration: 0.5))
            item1Number.run(SKAction.moveTo(y: size.height*0.20, duration: 0.5))
            item2.run(SKAction.moveTo(y: size.height*0.23, duration: 0.5))
            item2Number.run(SKAction.moveTo(y: size.height*0.20, duration: 0.5))
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            item1.run(SKAction.moveTo(y: playableRect.maxY*0.23, duration: 0.5))
            item1Number.run(SKAction.moveTo(y: playableRect.maxY*0.20, duration: 0.5))
            item2.run(SKAction.moveTo(y: playableRect.maxY*0.23, duration: 0.5))
            item2Number.run(SKAction.moveTo(y: playableRect.maxY*0.20, duration: 0.5))
        }
    }
    func hideItems() {
        item1.run(SKAction.fadeOut(withDuration: 0.2),completion:{[unowned self] in self.item1.run(SKAction.moveTo(y: -self.size.height*1.5, duration: 0.1))})
        item1Number.run(SKAction.fadeOut(withDuration: 0.2),completion:{[unowned self] in self.item1Number.run(SKAction.moveTo(y: -self.size.height*1.5, duration: 0.1))})
        item2.run(SKAction.fadeOut(withDuration: 0.2),completion:{[unowned self] in self.item2.run(SKAction.moveTo(y: -self.size.height*1.5, duration: 0.1))})
        item2Number.run(SKAction.fadeOut(withDuration: 0.2),completion:{[unowned self] in self.item2Number.run(SKAction.moveTo(y: -self.size.height*1.5, duration: 0.1))})
    }
    func useItem1() {
        guard GameViewController.amountOfItem1 >= 1 else {return}
        
        //Stop player from wasting item (Health points can't go over 3)
        if healthPoints < 3 {
            GameViewController.amountOfItem1 -= 1
            item1Number.text = "\(GameViewController.amountOfItem1)"
            healthPoints += 1
            
            if healthPoints == 3 {
                health1?.alpha = 1.0
                health2?.alpha = 1.0
                health3?.alpha = 1.0
            }
            else if healthPoints == 2 {
                health1?.alpha = 1.0
                health2?.alpha = 1.0
                health3?.alpha = 0.0
            }
            else if healthPoints == 1 {
                health1?.alpha = 1.0
                health2?.alpha = 0.0
                health3?.alpha = 0.0
            }
            else {
                health1?.alpha = 0.0
                health2?.alpha = 0.0
                health3?.alpha = 0.0
            }
        }
    }
    func useItem2() {
        guard GameViewController.amountOfItem2 >= 1 else {return}
        
        GameViewController.amountOfItem2 -= 1
        item2Number.text = "\(GameViewController.amountOfItem2)"
        //Explode all enemies
        for child in worldNode.children {
            if let node = child as? Enemy {
                if node.name!.contains("RedEnemy") {
                    explodeRedEnemy()
                }
                if node.name!.contains("GreenEnemy") {
                    explodeGreenEnemy()
                }
                if node.name!.contains("BlueEnemy") {
                    explodeBlueEnemy()
                }
                if node.name!.contains("YellowEnemy") {
                    explodeYellowEnemy()
                }
                if node.name!.contains("PinkEnemy") {
                    explodePinkEnemy()
                }
                if node.name!.contains("FastEnemy") {
                    explodeFastEnemy()
                }
                if node.name!.contains("ChargeEnemy") {
                    explodeChargeEnemy()
                }
                if node.name!.contains("InvisEnemy") {
                    explodeInvisEnemy()
                }
                if node.name!.contains("DarkEnemy") {
                    explodeDarkEnemy()
                }
            }
        }
    }
    
    func showCoin(position:CGPoint) {
        let coin = SKSpriteNode(texture: SKTexture(imageNamed: "CoinRotate1"), color: SKColor.clear, size: CGSize(width: 80, height: 80))
        coin.zPosition = 10
        coin.position = position
        worldNode.addChild(coin)
        
        //Flip animation
        coin.run(SKAction.animate(with: coinAnimation, timePerFrame: 0.07))
        coin.run(SKAction.sequence([SKAction.moveTo(y: position.y + (playableRect.maxY*0.08), duration: 0.15), SKAction.fadeOut(withDuration: 0.4)]), completion:{
            coin.removeFromParent()
        })
        
        GameViewController.coins += 1
        
        //TODO: Coin Sound Effect
        
    }
    
    //DEFEAT SCREEN
    func createDefeatScreen() {
        defeatScreen = SKSpriteNode(texture: SKTexture(imageNamed: "DefeatBg"), color: SKColor.clear, size: CGSize(width: 939, height: 830))
        defeatScreen.position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.64)
        defeatScreen.zPosition = 11
        defeatScreen.alpha = 0.0
        worldNode.addChild(defeatScreen)
        
        defeatRetryButton = SKSpriteNode(texture: SKTexture(imageNamed: "RetryButton"), color: SKColor.clear, size: CGSize(width: 205, height: 205))
        defeatRetryButton.position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.398)
        defeatRetryButton.zPosition = 12
        defeatRetryButton.alpha = 0.0
        worldNode.addChild(defeatRetryButton)
        
        defeatScoreLabel = SKLabelNode()
        defeatScoreLabel.position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.69)
        defeatScoreLabel.zPosition = 12
        defeatScoreLabel.text = "Score: \(score)"
        defeatScoreLabel.fontName = "Palatino-Bold"
        defeatScoreLabel.fontColor = SKColor.black
        defeatScoreLabel.fontSize = 92
        defeatScoreLabel.verticalAlignmentMode = .center
        defeatScoreLabel.horizontalAlignmentMode = .center
        defeatScoreLabel.alpha = 0.0
        worldNode.addChild(defeatScoreLabel)
        
        defeatBestScoreLabel = SKLabelNode()
        defeatBestScoreLabel.position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.58)
        defeatBestScoreLabel.zPosition = 12
        defeatBestScoreLabel.text = "Best: \(GameViewController.highScore)"
        defeatBestScoreLabel.fontName = "Palatino-Bold"
        defeatBestScoreLabel.fontColor = SKColor.black
        defeatBestScoreLabel.fontSize = 90
        defeatBestScoreLabel.verticalAlignmentMode = .center
        defeatBestScoreLabel.horizontalAlignmentMode = .center
        defeatBestScoreLabel.alpha = 0.0
        worldNode.addChild(defeatBestScoreLabel)
        
        hideDefeatScreen()
    }
    func showDefeatScreen() {
        guard healthPoints <= 0 else {return}
        for child in worldNode.children {
            if let node = child as? Enemy {
                node.removeAllActions()
                node.removeFromParent()
            }
        }
        
        scoreLabel.alpha = 0.0
        darknessScreen.alpha = 0.0
        self.removeAllActions()
        invokeRemoveAll()
        hideEverything(excludeButtons: false)
        hideItems()
        
        if score > GameViewController.highScore {GameViewController.highScore = score}
        highScoreLabel?.text = "Best: \(GameViewController.highScore)"
        
        defeatScreen.position.y = CGFloat(playableRect.maxY*0.64)
        defeatScreen.alpha = 1.0
        defeatRetryButton.position.y = CGFloat(playableRect.maxY*0.398)
        defeatRetryButton.alpha = 1.0
        defeatScoreLabel.position.y = CGFloat(playableRect.maxY*0.69)
        defeatScoreLabel.alpha = 1.0
        defeatBestScoreLabel.position.y = CGFloat(playableRect.maxY*0.58)
        defeatBestScoreLabel.alpha = 1.0
        
        //Save high score and number of items
        if let controller = self.view?.window?.rootViewController as? GameViewController {
            controller.save()
        }
    }
    func hideDefeatScreen() {
        //Animate
        defeatScreen.run(SKAction.moveTo(y: size.height*1.5, duration: 0.2),completion:{[unowned self] in self.defeatScreen.alpha = 0.0})
        defeatRetryButton.run(SKAction.moveTo(y: size.height*1.5, duration: 0.2),completion:{[unowned self] in self.defeatRetryButton.alpha = 0.0})
        defeatScoreLabel.run(SKAction.moveTo(y: size.height*1.5, duration: 0.2),completion:{[unowned self] in self.defeatScoreLabel.alpha = 0.0})
        defeatBestScoreLabel.run(SKAction.moveTo(y: size.height*1.5, duration: 0.2),completion:{[unowned self] in self.defeatBestScoreLabel.alpha = 0.0})
        
        //Reset game
        score = -1
        healthPoints = 3
    }
    
    //PARTICLES
    func particleAnimation(particleFileName:String, node:Enemy) {
        let particle = SKEmitterNode(fileNamed: particleFileName)
        particle!.targetNode = self
        particle!.position = node.position
        particle!.particleZPosition = 10
        worldNode.addChild(particle!)
        worldNode.run(SKAction.wait(forDuration: 1), completion: {particle!.removeFromParent()})
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
