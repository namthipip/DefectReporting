//
//  SubmitSuccessViewController.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 12/16/17.
//  Copyright © 2017 Namthip Silsuwan. All rights reserved.
//

import UIKit

class SubmitSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.dismissView), userInfo: nil, repeats: false)

        // Do any additional setup after loading the view.
    }
    
    func dismissView(){
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: {
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
