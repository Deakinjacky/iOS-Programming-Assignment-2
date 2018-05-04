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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        
        loadSettings()
        loadItems()
        
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
        return (documentsDirectory() as NSString).appendingPathComponent("Settings.plist")
    }
    
    func saveSettings() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(GameViewController.musicEnabled, forKey: "MusicEnabled")
        archiver.encode(GameViewController.soundEnabled, forKey: "SoundEnabled")
        
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    func loadSettings() {
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
            }
        }
    }
    
    func dataFilePathItems() -> String {
        return (documentsDirectory() as NSString).appendingPathComponent("Items.plist")
    }
    func saveItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(GameViewController.amountOfItem1, forKey: "AmountOfItem1")
        archiver.encode(GameViewController.amountOfItem1, forKey: "AmountOfItem2")
        
        archiver.finishEncoding()
        data.write(toFile: dataFilePathItems(), atomically: true)
    }
    func loadItems() {
        if FileManager.default.fileExists(atPath: dataFilePathItems()) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: dataFilePathItems())) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)

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
