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
//            let sb = UIStoryboard(name: "DefectRecord", bundle: nil)
//            let reportView = sb.instantiateViewController(withIdentifier: "DefectReportViewController") as! DefectReportViewController
            let currentView:UIViewController = UIApplication.topViewController()!
//            currentView.present(reportView, animated: true, completion: {
//                
//            })
            
            let reportTypeView = RecordTypeViewController(string: "thip")
            currentView.present(reportTypeView, animated: true, completion: {
                
            })
        }
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

