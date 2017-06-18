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
    
    static let sharedInstance : DefectRecordShareInstance = {
        let instance = DefectRecordShareInstance()
        return instance
    }()
    
    func registerWithEvent(event:EventType){
        
        if event == .shake {
            
        }
        if event == .doubleTap{
           
        }
        if event == .floatingButton {
            let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
            button.backgroundColor = UIColor.blue
            let window = UIApplication.shared.delegate?.window
            window??.addSubview(button)
            button.isUserInteractionEnabled = true
            
        }
    }
    
    public func showAnnotationView() {
        let currentView:UIViewController = UIApplication.topViewController()!
        if currentView is RecordTypeViewController {
            return
        }
        
        let reportTypeView = RecordTypeViewController(string: "thip")
        reportTypeView.modalPresentationStyle = .overCurrentContext
        currentView.present(reportTypeView, animated: true, completion: {
            
        })
    }
    
}
