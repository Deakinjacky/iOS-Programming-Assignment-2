//
//  PurpleEnemy.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 5/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit

class PinkEnemy: Enemy {
    
    init() {
        super.init(SPD: 28)
        self.texture = SKTexture(imageNamed: "Pink1")
        self.size = CGSize(width: 240, height: 200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
