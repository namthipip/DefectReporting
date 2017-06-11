//
//  DefectRecordShareInstance.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/9/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import Foundation
import UIKit

enum EventType {
    case shake
    case doubleTap
    case floatingButton
}

public class DefectRecordShareInstance : NSObject{
    
    let notificationName = NSNotification.Name(rawValue: "DeviceShaken")
    
    func registerWithEvent(event:EventType){
        NotificationCenter.default.addObserver(self, selector: #selector(self.haldlerDeviceShake(sender:)), name: notificationName, object: nil)
        
        if event == .shake {
            NotificationCenter.default.post(name: notificationName, object: self)
        }
        if event == .doubleTap{
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handlerTapGesture(gesture:)))
            doubleTapGesture.numberOfTapsRequired = 2
            //UIApplication.shared.windows[0].rootViewController?.view.addGestureRecognizer(doubleTapGesture)
//            let rootView = UIApplication.shared.keyWindow
//            rootView.windowLevel = CGFloat.greatestFiniteMagnitude
//            rootView.isUserInteractionEnabled = true
//            rootView.addGestureRecognizer(doubleTapGesture)
           
        }
        if event == .floatingButton {
            let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
            button.backgroundColor = UIColor.blue
            let window = UIApplication.shared.delegate?.window
            window??.addSubview(button)
            button.isUserInteractionEnabled = true
            button.addTarget(self, action: #selector(self.haldlerDeviceShake(sender:)), for: .touchUpInside)
        }
    }
    
    public func showReportView() {
        let reportView = UIStoryboard(name: "DefectRecord", bundle: nil).instantiateViewController(withIdentifier: "DefectReportViewController") as! DefectReportViewController
        let currentView:UIViewController = UIApplication.topViewController()!
        currentView.present(reportView, animated: true, completion: {
            
        })
    }
    
    func haldlerDeviceShake(sender:AnyObject) {
        print("Device Shake")
    }
    
    func handlerTapGesture(gesture:UITapGestureRecognizer){
        print("double tap")
    }
}
