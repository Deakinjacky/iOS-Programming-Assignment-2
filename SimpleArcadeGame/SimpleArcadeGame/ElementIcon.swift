//
//  ElementIcon.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 2/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit

class ElementIcon:SKSpriteNode {
    init(image:SKTexture) {
        super.init(texture: image, color: SKColor.clear, size: CGSize(width: 270, height: 270))
        self.alpha = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
