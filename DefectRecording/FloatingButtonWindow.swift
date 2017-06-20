//
//  FloatingButtonWindow.swift
//  TextToSpeech
//
//  Created by Namthip Silsuwan on 10/10/2559 BE.
//  Copyright © 2559 Namthip Silsuwan. All rights reserved.
//

import UIKit

class FloatingButtonWindow: UIWindow {
    
    var button: UIButton?
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let button = button else { return false }
        let buttonPoint = convert(point, to: button)
        return button.point(inside: buttonPoint, with: event)
    }

}
