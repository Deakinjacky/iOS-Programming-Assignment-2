//
//  ChargeEnemy.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 5/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit

class ChargeEnemy: Enemy {
    
    init() {
        //Move by 0.2
        super.init(SPD: 5)
        self.texture = SKTexture(imageNamed: "Charge1")
        self.size = CGSize(width: 320, height: 235)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
