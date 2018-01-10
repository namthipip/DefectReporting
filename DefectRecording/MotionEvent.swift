//
//  MotionEvent.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/9/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import Foundation
import UIKit

class MotionEvent{
    
}

extension UIWindow{
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    override open func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("device shake")
            DefectRecordShareInstance.sharedInstance.showAnnotationView()
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.tapCount == 2 {
            print("double tap")
            DefectRecordShareInstance.sharedInstance.showAnnotationView()
        }
    }
    
    
    func capture() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

