//
//  GameViewController.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 2/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    //Settings
    static var soundEnabled:Bool = true
    static var musicEnabled:Bool = true
    
    //Items
    static var amountOfItem1:Int = 60
    static var amountOfItem2:Int = 60
    
    static var highScore:Int = 0
    static var coins:Int = 999
    
    //MUSIC
    static var gameplayAudioPlayer: AVAudioPlayer!
    
    //Sound Fx
    static let buttonSoundFx = SKAction.playSoundFileNamed("Button", waitForCompletion: false)
    static let invokeSoundFx = SKAction.playSoundFileNamed("Invoke", waitForCompletion: false)
    static let damageSoundFx = SKAction.playSoundFileNamed("Damaged", waitForCompletion: false)
    static let buySoundFx = SKAction.playSoundFileNamed("Buy", waitForCompletion: false)
    static let errorSoundFx = SKAction.playSoundFileNamed("Error", waitForCompletion: false)
    static let defeatSoundFx = SKAction.playSoundFileNamed("Defeat", waitForCompletion: false)
    static let coin1SoundFx = SKAction.playSoundFileNamed("Coin1", waitForCompletion: false)
    static let coin2SoundFx = SKAction.playSoundFileNamed("Coin2", waitForCompletion: false)
    static var coinVariation:Int = 1
    static let explode1SoundFx = SKAction.playSoundFileNamed("Explode3", waitForCompletion: false)
    static var explodeVariation:Int = 1
    static let closeSoundFx = SKAction.playSoundFileNamed("Close", waitForCompletion: false)
    static let item1SoundFx = SKAction.playSoundFileNamed("Item1", waitForCompletion: false)
    static let item2SoundFx = SKAction.playSoundFileNamed("Item2", waitForCompletion: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        
        load()
        
        //Make it 1 screen size
        let scene = GameScene(size: CGSize(width: 2048, height: 1536))
        let skView = self.view as! SKView
        
        skView.showsFPS = true
        skView.ignoresSiblingOrder = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        GameViewController.prepareMusic()
    }
    
    static func prepareMusic() {
        guard GameViewController.musicEnabled == true else {return}
        
        //MUSIC
        let gameplayAudioFilePath = Bundle.main.path(forResource: "GameplayMusic", ofType: "wav")
        let gameplayAudioUrl = NSURL(fileURLWithPath: gameplayAudioFilePath!)
        GameViewController.gameplayAudioPlayer = try! AVAudioPlayer(contentsOf: gameplayAudioUrl as URL)
        GameViewController.gameplayAudioPlayer.prepareToPlay()
        GameViewController.gameplayAudioPlayer.currentTime = 0.0
        GameViewController.gameplayAudioPlayer.volume = 0.7
        GameViewController.gameplayAudioPlayer.numberOfLoops = -1
        
        if GameViewController.musicEnabled {
           GameViewController.gameplayAudioPlayer.play()
        }
    }
    
    //SAVE + LOAD
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).appendingPathComponent("Level.plist")
    }
    
    func save() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(GameViewController.musicEnabled, forKey: "MusicEnabled")
        archiver.encode(GameViewController.soundEnabled, forKey: "SoundEnabled")
        
        archiver.encode(GameViewController.amountOfItem1, forKey: "AmountOfItem1")
        archiver.encode(GameViewController.amountOfItem2, forKey: "AmountOfItem2")
        
        archiver.encode(GameViewController.highScore, forKey: "Highscore")
        archiver.encode(GameViewController.coins, forKey: "Coins")
        
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    func load() {
        if FileManager.default.fileExists(atPath: dataFilePath()) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: dataFilePath())) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                
                //Music
                if (unarchiver.decodeObject(forKey: "MusicEnabled") as? Bool) == nil {
                    GameViewController.musicEnabled = unarchiver.decodeBool(forKey: "MusicEnabled")
                }
                else {
                    GameViewController.musicEnabled = (unarchiver.decodeObject(forKey: "MusicEnabled") as! Bool)
                }
                //Sound
                if (unarchiver.decodeObject(forKey: "SoundEnabled") as? Bool) == nil {
                    GameViewController.soundEnabled = unarchiver.decodeBool(forKey: "SoundEnabled")
                }
                else {
                    GameViewController.soundEnabled = (unarchiver.decodeObject(forKey: "SoundEnabled") as! Bool)
                }
                //Item1
                if (unarchiver.decodeObject(forKey: "AmountOfItem1") as? Int) == nil {
                    GameViewController.amountOfItem1 = unarchiver.decodeInteger(forKey: "AmountOfItem1")
                }
                else {
                    GameViewController.amountOfItem1 = (unarchiver.decodeObject(forKey: "AmountOfItem1") as! Int)
                }
                //Item2
                if (unarchiver.decodeObject(forKey: "AmountOfItem2") as? Int) == nil {
                    GameViewController.amountOfItem2 = unarchiver.decodeInteger(forKey: "AmountOfItem2")
                }
                else {
                    GameViewController.amountOfItem2 = (unarchiver.decodeObject(forKey: "AmountOfItem2") as! Int)
                }
                //High score
                if (unarchiver.decodeObject(forKey: "Highscore") as? Int) == nil {
                    GameViewController.highScore = unarchiver.decodeInteger(forKey: "Highscore")
                }
                else {
                    GameViewController.highScore = (unarchiver.decodeObject(forKey: "Highscore") as! Int)
                }
                //Coins
                if (unarchiver.decodeObject(forKey: "Coins") as? Int) == nil {
                    GameViewController.coins = unarchiver.decodeInteger(forKey: "Coins")
                }
                else {
                    GameViewController.coins = (unarchiver.decodeObject(forKey: "Coins") as! Int)
                }
                
            }
        }
    }
    
    static func playSound(fx:String, scene:SKNode) {
        guard GameViewController.soundEnabled == true else {return}
        if fx == "button" {scene.run(buttonSoundFx)}
        else if fx == "invoke" {scene.run(invokeSoundFx)}
        else if fx == "buy" {scene.run(buySoundFx)}
        else if fx == "defeat" {scene.run(defeatSoundFx)}
        else if fx == "coin" {
            if GameViewController.coinVariation == 1 {scene.run(coin1SoundFx);GameViewController.coinVariation = 2}
        else if GameViewController.coinVariation == 2 {scene.run(coin2SoundFx);GameViewController.coinVariation = 1}
        }
        else if fx == "error" {scene.run(errorSoundFx)}
        else if fx == "explode" {scene.run(explode1SoundFx)}
        else if fx == "close" {scene.run(closeSoundFx)}
        else if fx == "damage" {scene.run(damageSoundFx)}
        else if fx == "item1" {scene.run(item1SoundFx)}
        else if fx == "item2" {scene.run(item2SoundFx)}
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
