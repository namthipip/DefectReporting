//
//  DefectRecordShareInstance.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/9/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import Foundation
import UIKit
import Photos

enum EventType {
    case shake
    case doubleTap
    case floatingButton
}

public class DefectRecordShareInstance : NSObject{
    
    var floatingButtonController:FloatingButtonController?
    
    var screenRecoder:ASScreenRecorder!
    
    var timer = Timer()
    
    var recordDuration = 0
    
    static let sharedInstance : DefectRecordShareInstance = {
        let instance = DefectRecordShareInstance()
        instance.floatingButtonController?.showFloatingBtn(needShow: false)
        instance.screenRecoder = ASScreenRecorder.sharedInstance()
        UIDevice.current.isBatteryMonitoringEnabled = true
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
        #if DEBUG
            let currentView:UIViewController = UIApplication.topViewController()!
            if currentView is RecordTypeViewController ||
                currentView is DrawingViewController {
                return
            }
            
            let reportTypeView = RecordTypeViewController(string: "thip")
            reportTypeView.modalPresentationStyle = .overCurrentContext
            currentView.present(reportTypeView, animated: true, completion: {
                
            })
        #else
            
        #endif
        
    }
    
    func didTapButton() {
        print("Tap Button")
    }
    
    func startRecording(sender: UIButton){
        print("Start screen record")
        screenRecoder.videoURL = getVideoFilePath()
        screenRecoder.startRecording()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateRecordTime), userInfo: nil, repeats: true)
        
        sender.removeTarget(self, action: #selector(self.startRecording(sender:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(self.stopRecording(sender:)), for: .touchUpInside)
        
    }
    
    func stopRecording(sender: UIButton) {
        print("Stop screen record")
        screenRecoder.stopRecording { 
            self.floatingButtonController?.showFloatingBtn(needShow: false)
            self.recordDuration = 0
            self.timer.invalidate()
            sender.removeTarget(self, action: #selector(self.stopRecording(sender:)), for: .touchUpInside)
            sender.addTarget(self, action: #selector(self.startRecording(sender:)), for: .touchUpInside)
            
            let currentView:UIViewController = UIApplication.topViewController()!
            self.saveVideoRecordFile()
            let activityItem = self.getVideoFilePath()
            self.screenRecoder.videoURL = nil
            let activityVc = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
            currentView.present(activityVc, animated: true, completion: nil)
            
         }
    }
    
    func updateRecordTime(){
        recordDuration = recordDuration + 1
        let minutes = recordDuration / 60 % 60
        let seconds = recordDuration % 60
        let timeString = String(format:"%02i:%02i", minutes, seconds)
        self.floatingButtonController?.updateRecordTime(timeStr: timeString)
    }

    func getImageFromBundle(name: String) -> UIImage {
        let podBundle = Bundle(for: DefectRecordShareInstance.self)
        return UIImage(named: name, in: podBundle, compatibleWith: nil)!
    }
    
    func redirectLogToDocuments() {
        #if DEBUG
        if UIDevice.current.batteryState != .charging{
            freopen(getLogFilePath().cString(using: String.Encoding.ascii)!, "a+", stderr)
        }
        #else
            
        #endif
        
    }
    
    func getVideoFilePath() -> URL {
        return URL(fileURLWithPath: NSHomeDirectory().appending("/tmp/screenCapture.mp4"))
    }
        
    
    func getLogFilePath() -> String {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/mm/yy hh:mm"
        return documentsDirectory + "/debug_log_\(dateformatter.string(from: Date())).txt"
    }
    
    func deleteLogFile() {
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: URL(fileURLWithPath: getLogFilePath()))
        
    }
    
    func saveVideoRecordFile(){
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.getVideoFilePath())
        }) { saved, error in
        }
    }
    
    
    
}

extension UITextField {
    func addRightView(){
        self.rightViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageView.image = DefectRecordShareInstance.sharedInstance.getImageFromBundle(name:"shop-dropdown")
        self.rightView = imageView
    }
}

extension UIButton {
    func setCornerCircle(){
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    func setCornerCircleWithoutBorderLine(){
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
    }
}
