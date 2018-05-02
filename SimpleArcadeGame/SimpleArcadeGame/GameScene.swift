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
    
    var background:SKSpriteNode!
    
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
            
            if button1.contains(touchPosition) {
                createElement(name: button1.name!)
            }
            else if button2.contains(touchPosition) {
                createElement(name: button2.name!)
            }
            else if button3.contains(touchPosition) {
                createElement(name: button3.name!)
            }
            if invokeButton.contains(touchPosition) {
                invoke()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func initialiseLevel() {
        background = SKSpriteNode(texture: SKTexture(imageNamed:"Background"), color: SKColor.clear, size: CGSize(width: 2048, height: 1536))
        background.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        //Appears behind all nodes
        background.zPosition = -10
        addChild(background)
        
        //Destroy this bird to start game
        spawnInitialRedEnemy()
        
        createButtons()
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
        
        coinsIcon = SKSpriteNode(texture: SKTexture(imageNamed: "Coin"))
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
        
        //Element Postions
        element1Position = CGPoint(x: size.width*0.4, y: playableRect.maxY*0.509)
        element2Position = CGPoint(x: size.width*0.5, y: playableRect.maxY*0.509)
        element3Position = CGPoint(x: size.width*0.6, y: playableRect.maxY*0.509)
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
    
    //TODO:
    func invoke() {
        //Destroy enemy if combination matches
        if element1Name == "Red" && element2Name == "Red" && element3Name == "Red" {
            //explodeRedEnemy()
            explodeInitialRedEnemy()
        }
        else if element1Name == "Blue" && element2Name == "Blue" && element3Name == "Blue" {
    
        }
        else if element1Name == "Green" && element2Name == "Green" && element3Name == "Green" {
    
        }
        else if element1Name == "Red" && element2Name == "Blue" && element3Name == "Green" {
       
        }
        else if element1Name == "Red" && element2Name == "Red" && element3Name == "Blue" {
  
        }
        else if element1Name == "Blue" && element2Name == "Blue" && element3Name == "Green" {
  
        }
        else if element1Name == "Green" && element2Name == "Green" && element3Name == "Red" {
  
        }
        else if element1Name == "Green" && element2Name == "Blue" && element3Name == "Green" {

        }
        else if element1Name == "Blue" && element2Name == "Red" && element3Name == "Red" {
     
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
        //TODO: Physics Body to damage player
        
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
        
        //TODO: ANIMATION
        
        //TODO: Recover back to normal amount of HP
        //startingHealthPoint = healthPoints
    }
    
    //DESTROY
    func explodeInitialRedEnemy() {
        for node in worldNode.children {
            if let child = node as? Enemy {
                if child.name == "InitialRedEnemy" {
                    child.removeAllActions()
                    //TODO: Explode Animation
                    //child.run(SKAction.animate(with: redEnemyExplosionFrames, timePerFrame: 0.09), completion: {
                        //child.removeFromParent()})
                    //TODO:
                    //beginGame()
                    //uiNode.run(redExplode1Fx)
                    child.removeFromParent()
                    break;
                }
            }
        }
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
