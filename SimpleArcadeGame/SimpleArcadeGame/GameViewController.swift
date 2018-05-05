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

class GameViewController: UIViewController {
    
    //Settings
    static var soundEnabled:Bool = true
    static var musicEnabled:Bool = true
    
    //Items
    static var amountOfItem1:Int = 60
    static var amountOfItem2:Int = 60
    
    static var highScore:Int = 0
    static var coins:Int = 999

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
    }
    
    static func playSound(fx:String) {
        guard GameViewController.soundEnabled == true else {return}
        if fx == "GameplayButton" {}
    }
    static func prepareMusic() {
        guard GameViewController.musicEnabled == true else {return}
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
