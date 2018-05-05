//
//  BlueEnemy.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 5/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit

class BlueEnemy:Enemy {
    init() {
        super.init(SPD: 30)
        self.texture = SKTexture(imageNamed: "Blue1")
        self.size = CGSize(width: 245, height: 175)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

