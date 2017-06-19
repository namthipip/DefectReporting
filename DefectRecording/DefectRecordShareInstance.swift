//
//  DefectRecordShareInstance.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/9/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import Foundation
import UIKit
import ReplayKit

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
    
    var buttonWindow: UIWindow!
    
    let screenSize =  UIScreen.main.bounds
    
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
    
    func addButtons() {
        let recordingButton = UIButton(frame: CGRect(x: screenSize.width/2 - 35, y: screenSize.height - 100, width: 70, height: 70))
        recordingButton.setImage(#imageLiteral(resourceName: "rodentia-icons_media-record.png"), for: .normal)
        recordingButton.addTarget(self, action: #selector(self.startRecording(sender:)), for: .touchUpInside)
        
        self.buttonWindow = UIWindow(frame: screenSize)
        self.buttonWindow.rootViewController = HiddenStatusBarViewController()
        self.buttonWindow.rootViewController?.view.addSubview(recordingButton)
        self.buttonWindow.makeKeyAndVisible()
        
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
    
    func startRecording(sender: UIButton){
        print("Start screen record")
        if RPScreenRecorder.shared().isAvailable {
            RPScreenRecorder.shared().startRecording(handler: { (error) in
                if error == nil{
                    sender.removeTarget(self, action: #selector(self.startRecording(sender:)), for: .touchUpInside)
                    sender.addTarget(self, action: #selector(self.stopRecording(sender:)), for: .touchUpInside)
                    //sender.setTitle("Stop Recording", for: .normal)
                    //sender.setTitleColor(UIColor.red, for: .normal)
                    
                    sender.setImage(#imageLiteral(resourceName: "player_record.png"), for: .normal)
                }
                else{
                    // Handle error
                }
            })
        }
        else{
            // Display UI for recording being unavailable
        }
    }
    
    func stopRecording(sender: UIButton) {
        print("Stop screen record")
        RPScreenRecorder.shared().stopRecording { (previewController, error) in
            if previewController != nil {
                let alertCtrl = UIAlertController(title: "Recording", message: "message", preferredStyle: .alert)
                let discardAction = UIAlertAction(title: "Discard", style: .default, handler: { (alert) in
                    RPScreenRecorder.shared().discardRecording(handler: {
                        
                    })
                })
                
                let viewAction = UIAlertAction(title: "View", style: .default, handler: { (alert) in
                    let currentView:UIViewController = UIApplication.topViewController()!
                    currentView.present(previewController!, animated: true, completion: nil)
                })
                
                alertCtrl.addAction(discardAction)
                alertCtrl.addAction(viewAction)
                
                //self.present(alertCtrl, animated: true, completion: nil)
                
                print(self.buttonWindow.rootViewController)
                self.buttonWindow.rootViewController?.present(alertCtrl, animated: true, completion: nil)
                
                sender.removeTarget(self, action: #selector(self.stopRecording(sender:)), for: .touchUpInside)
                sender.addTarget(self, action: #selector(self.startRecording(sender:)), for: .touchUpInside)
                //sender.setTitle("Start Recording", for: .normal)
                //sender.setTitleColor(UIColor.blue, for: .normal)
                sender.setImage(#imageLiteral(resourceName: "rodentia-icons_media-record.png"), for: .normal)
            }
            else
            {
                // Handle error
            }
            
            
        }
    }
    
}
