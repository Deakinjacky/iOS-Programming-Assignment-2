//
//  FastEnemy.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 5/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit

class FastEnemy: Enemy {
    
    init() {
        super.init(SPD: 16)
        self.texture = SKTexture(imageNamed: "Fast1")
        self.size = CGSize(width: 280, height: 190)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
