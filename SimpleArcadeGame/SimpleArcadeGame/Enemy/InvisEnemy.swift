//
//  PinkEnemy.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 5/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit

class InvisEnemy: Enemy {
    
    init() {
        super.init(SPD: 27)
        self.texture = SKTexture(imageNamed: "Invis1")
        self.size = CGSize(width: 240, height: 240)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
