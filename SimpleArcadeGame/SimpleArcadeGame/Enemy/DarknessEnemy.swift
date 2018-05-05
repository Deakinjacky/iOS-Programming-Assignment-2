//
//  DarknessEnemy.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 5/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit

class DarknessEnemy: Enemy {
    
    init() {
        super.init(SPD: 23)
        self.texture = SKTexture(imageNamed: "Dark1")
        self.size = CGSize(width: 400, height: 190)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
