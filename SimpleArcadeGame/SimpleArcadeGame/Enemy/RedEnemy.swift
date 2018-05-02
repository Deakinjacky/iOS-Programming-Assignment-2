//
//  RedEnemy.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 2/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit

class RedEnemy:Enemy {
    init() {
        super.init(SPD: 30)
        self.texture = SKTexture(imageNamed: "Red1")
        self.size = CGSize(width: 240, height: 170)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
