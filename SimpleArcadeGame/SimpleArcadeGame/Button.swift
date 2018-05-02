//
//  Button.swift
//  SimpleArcadeGame
//
//  Created by Jacky Chen on 2/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import SpriteKit

class Button:SKSpriteNode {
    
    init(name: String, image:SKTexture) {
        super.init(texture: image, color: SKColor.clear, size: CGSize(width: 180, height: 180))
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
