//
//  YellowEnemy.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 5/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit

class YellowEnemy:Enemy {
    init() {
        super.init(SPD: 30)
        self.texture = SKTexture(imageNamed: "Yellow1")
        self.size = CGSize(width: 300, height: 182)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

