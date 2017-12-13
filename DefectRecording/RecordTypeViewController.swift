//
//  RecordTypeViewController.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/11/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import UIKit

class RecordTypeViewController: UIViewController {

    
    @IBOutlet weak var viewAnnotaionType: UIView!
    
    public init(string:String){
        super.init(nibName: "RecordTypeViewController", bundle: Bundle(for: RecordTypeViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewAnnotaionType.layer.cornerRadius = 10
        viewAnnotaionType.layer.masksToBounds = true
    }
    
    
    @IBAction func commentTap(_ sender: Any) {
        
    }
    
    @IBAction func screenRecordTap(_ sender: Any) {
        self.dismiss(animated: true) { 
            let window: UIWindow! = UIApplication.shared.keyWindow
            let drawingView = DrawingViewController(image: window.capture())
            let currentView:UIViewController = UIApplication.topViewController()!
            currentView.present(drawingView, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func videoRecoedTap(_ sender: Any) {
        self.dismiss(animated: true) {
//            DefectRecordShareInstance.sharedInstance.floatingButtonController?.button.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
            DefectRecordShareInstance.sharedInstance.addRecordHandler()
            DefectRecordShareInstance.sharedInstance.floatingButtonController?.showFloatingBtn(needShow: true)
        }
        
    }
    
    func didTapButton() {
        print("Tap Button")
    }
    
    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
