//
//  Enemy.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 2/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    var speedOfMonster: Double
    var isDead:Bool = false
    
    init(SPD: Double) {
        self.speedOfMonster = SPD
        
        super.init(texture: nil, color: SKColor.clear, size: CGSize(width: 100, height: 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
