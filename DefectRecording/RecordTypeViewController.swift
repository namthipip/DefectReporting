//
//  RecordTypeViewController.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/11/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import UIKit

public class CameraGlobals {
    public static let shared = CameraGlobals()
    public var bundle = Bundle(for: RecordTypeViewController.self)
}

class RecordTypeViewController: UIViewController {

    @IBOutlet weak var screenShotLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public init(string:String){
        super.init(nibName: "RecordTypeViewController", bundle: CameraGlobals.shared.bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
