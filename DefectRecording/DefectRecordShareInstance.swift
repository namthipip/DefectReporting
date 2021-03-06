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
            currentView is DrawingViewController ||
            currentView is DefectAddDetailViewController {
            return
        }
        
        let reportTypeView = RecordTypeViewController(string: "thip")
        reportTypeView.modalPresentationStyle = .overCurrentContext
        currentView.present(reportTypeView, animated: true, completion: {
            
        })
        #endif
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
            self.saveVideoRecordFile()
            self.floatingButtonController?.showFloatingBtn(needShow: false)
            self.timer.invalidate()
            self.recordDuration = 0
            sender.removeTarget(self, action: #selector(self.stopRecording(sender:)), for: .touchUpInside)
            sender.addTarget(self, action: #selector(self.startRecording(sender:)), for: .touchUpInside)
            let recordImage = DefectRecordShareInstance.sharedInstance.getImageFromBundle(name:"rec-button")
            sender.setImage(recordImage, for: .normal)
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
            if (isatty(STDERR_FILENO) == 0){
                freopen(self.getLogFilePath().cString(using: String.Encoding.ascii)!, "a+", stderr)
            }
        #endif
    }
        
    
    func getLogFilePath() -> String {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        return documentsDirectory + "/debug_log.txt"
    }
    
    func getVideoFilePath() -> URL {
        return URL(fileURLWithPath: NSHomeDirectory().appending("/tmp/screenCapture.mp4"))
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
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = DefectRecordShareInstance.sharedInstance.getImageFromBundle(name:"icon_dropdown")
        self.rightView = imageView
    }
}

extension UIView {
    func setBorderRadius(radius:CGFloat)    {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    func setBorderColor(color:UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
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
