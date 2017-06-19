//
//  ScreenRecordViewController.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/19/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import UIKit
import ReplayKit

class ScreenRecordViewController: UIViewController {
    
    var buttonWindow: UIWindow!
    
    public init(){
        super.init(nibName: "ScreenRecordViewController", bundle: Bundle(for: ScreenRecordViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recordingButton = UIButton(frame: CGRect(x: view.frame.width/2 - 35, y: view.frame.height - 100, width: 70, height: 70))
        //recordingButton.setTitle("Start Recording", for: .normal)
        //recordingButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        recordingButton.setImage(#imageLiteral(resourceName: "rodentia-icons_media-record.png"), for: .normal)
        recordingButton.addTarget(self, action: #selector(self.startRecording(sender:)), for: .touchUpInside)
        
        self.addButtons(buttons: [recordingButton])

        // Do any additional setup after loading the view.
    }
    
    func addButtons(buttons: [UIButton]) {
        self.buttonWindow = UIWindow(frame: self.view.frame)
        self.buttonWindow.rootViewController = HiddenStatusBarViewController()
        for button in buttons {
            self.buttonWindow.rootViewController?.view.addSubview(button)
        }
        
        self.buttonWindow.makeKeyAndVisible()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextview(_ sender: Any) {
        let defectDetailView = DefectAddDetailViewController(image: #imageLiteral(resourceName: "MagCover59.jpg"))
        self.present(defectDetailView, animated: true, completion: nil)

    }
    
    func startRecording(sender: UIButton){
        if RPScreenRecorder.shared().isAvailable {
            RPScreenRecorder.shared().startRecording(withMicrophoneEnabled: true, handler: { (error) in
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
        
        RPScreenRecorder.shared().stopRecording { (previewController, error) in
            if previewController != nil {
                let alertCtrl = UIAlertController(title: "Recording", message: "message", preferredStyle: .alert)
                let discardAction = UIAlertAction(title: "Discard", style: .default, handler: { (alert) in
                    RPScreenRecorder.shared().discardRecording(handler: { 
                        
                    })
                })
                
                let viewAction = UIAlertAction(title: "View", style: .default, handler: { (alert) in
                    self.present(previewController!, animated: true, completion: nil)
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
