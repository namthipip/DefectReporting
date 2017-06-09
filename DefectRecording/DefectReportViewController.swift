//
//  ViewController.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/4/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import UIKit

class DefectReportViewController: UIViewController {
    
    let notificationName = NSNotification.Name.NSFileHandleConnectionAccepted
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.addObserver(DefectRecordShareInstance(), selector: #selector(DefectRecordShareInstance.showPopup(sender:)), name: notificationName, object: nil)
        DefectRecordShareInstance().registerWithEvent(event: .shake)
        
    }
    
    func deviceShake(){
        print("Device Shake")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            //print("Why are you shaking me?")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }


}

