//
//  RecordTypeViewController.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/11/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import UIKit

public class DefectRecordGlobals {
    public static let shared = DefectRecordGlobals()
    public var bundle = Bundle(for: RecordTypeViewController.self)
}

class RecordTypeViewController: UIViewController {

    
    @IBOutlet weak var viewAnnotaionType: UIView!
    
    public init(string:String){
        super.init(nibName: "RecordTypeViewController", bundle: DefectRecordGlobals.shared.bundle)
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
        
    }
    
    @IBAction func videoRecoedTap(_ sender: Any) {
        
    }
    
    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
