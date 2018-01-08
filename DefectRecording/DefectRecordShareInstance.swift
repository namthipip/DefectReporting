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
    
    var second = 0
    
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
    }
    
    func didTapButton() {
        print("Tap Button")
    }
    
    func startRecording(sender: UIButton){
        print("Start screen record")
        screenRecoder.videoURL = URL(fileURLWithPath: NSHomeDirectory().appending("/tmp/screenCapture.mp4"))
        screenRecoder.startRecording()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateRecordTime), userInfo: nil, repeats: true)
        
        sender.removeTarget(self, action: #selector(self.startRecording(sender:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(self.stopRecording(sender:)), for: .touchUpInside)
        //sender.setTitle("Stop Recording", for: .normal)
        //sender.setTitleColor(UIColor.red, for: .normal)
        let recordImage = DefectRecordShareInstance.sharedInstance.getImageFromBundle(name:"record")
        sender.setImage(recordImage, for: .normal)
        
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
        second = second + 1
        let hours = second / 3600
        let minutes = second / 60 % 60
        let seconds = second % 60
        let timeString = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        self.floatingButtonController?.updateRecordTime(timeStr: timeString)
    }

    func getImageFromBundle(name: String) -> UIImage {
        let podBundle = Bundle(for: DefectRecordShareInstance.self)
        return UIImage(named: name, in: podBundle, compatibleWith: nil)!
    }
    
    func redirectLogToDocuments() {
//        let fileManager = FileManager.default
//        if !fileManager.fileExists(atPath: getFilePath()) {
//            fileManager.createFile(atPath: getFilePath(), contents: Data(), attributes: nil)
//        }
        //        let fileHandle = FileHandle.init(forWritingAtPath: getFilePath())
        //        fileHandle?.truncateFile(atOffset:(fileHandle?.seekToEndOfFile())!)
        //        let msg = String.init(format: "", __builtin_va_list)
        //        fileHandle?.write(__darwin_va_list)
        //        fileHandle?.closeFile()
        if UIDevice.current.batteryState != .charging{
            freopen(getFilePath().cString(using: String.Encoding.ascii)!, "a+", stderr)
        }
    }
        
    
    func getFilePath() -> String {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        return documentsDirectory + "/debug_log.txt"
    }
    
    func deleteLogFile() {
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: URL(fileURLWithPath: getFilePath()))
        
    }
    
    
    
}
    

extension DefectRecordShareInstance : RPPreviewViewControllerDelegate{
    
    public func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        print(activityTypes)
        previewController.dismiss(animated: true, completion: nil)
        
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
