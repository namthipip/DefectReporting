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
    
    var floatingButtonController:FloatingButtonController?
    
    var screenRecoder:ASScreenRecorder!
    
    var timer = Timer()
    
    static let sharedInstance : DefectRecordShareInstance = {
        let instance = DefectRecordShareInstance()
        instance.floatingButtonController?.showFloatingBtn(needShow: false)
        instance.screenRecoder = ASScreenRecorder.sharedInstance()
        return instance
    }()
    
    let themeColor = UIColor(red: 69/255.0, green: 182/255.0, blue: 74/255.0, alpha: 1)

    
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
    
    func addRecordHandler(){
        floatingButtonController = FloatingButtonController()
        floatingButtonController?.button.addTarget(self, action: #selector(DefectRecordShareInstance.startRecording(sender:)), for: .touchUpInside)

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
    
    func didTapButton() {
        print("Tap Button")
    }
    
    func startRecording(sender: UIButton){
        print("Start screen record")
        screenRecoder.videoURL = URL(fileURLWithPath: NSHomeDirectory().appending("/tmp/screenCapture.mp4"))
        screenRecoder.startRecording()
        var second = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            second = second + 1
            let hours = second / 3600
            let minutes = second / 60 % 60
            let seconds = second % 60
            let timeString = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            self.floatingButtonController?.updateRecordTime(timeStr: timeString)
        }
        sender.removeTarget(self, action: #selector(self.startRecording(sender:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(self.stopRecording(sender:)), for: .touchUpInside)
        //sender.setTitle("Stop Recording", for: .normal)
        //sender.setTitleColor(UIColor.red, for: .normal)
        
        sender.setImage(#imageLiteral(resourceName: "record"), for: .normal)
        
    }
    
    func stopRecording(sender: UIButton) {
        print("Stop screen record")
        screenRecoder.stopRecording { 
            self.floatingButtonController?.showFloatingBtn(needShow: false)
            self.timer.invalidate()
            sender.removeTarget(self, action: #selector(self.stopRecording(sender:)), for: .touchUpInside)
            sender.addTarget(self, action: #selector(self.startRecording(sender:)), for: .touchUpInside)
            //sender.setTitle("Start Recording", for: .normal)
            //sender.setTitleColor(UIColor.blue, for: .normal)
            sender.setImage(#imageLiteral(resourceName: "rec-button"), for: .normal)
            do{
                let videoData = try Data(contentsOf: self.screenRecoder.videoURL)
                print(videoData)
                let currentView:UIViewController = UIApplication.topViewController()!
                let defectDetailView = DefectAddDetailViewController(videoUrl: self.screenRecoder.videoURL)
                self.screenRecoder.videoURL = nil
                defectDetailView.navigationItem.hidesBackButton = true
                let navigation = UINavigationController(rootViewController: defectDetailView)
                currentView.present(navigation, animated: true, completion: nil)
            }
            catch{
            
            }
            
         }
    }
    
}

extension DefectRecordShareInstance : RPPreviewViewControllerDelegate{
    
    public func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        print(activityTypes)
        previewController.dismiss(animated: true, completion: nil)
        
    }
    
}
