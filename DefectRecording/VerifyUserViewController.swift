//
//  VerifyUserViewController.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 4/19/2561 BE.
//  Copyright © 2561 Namthip Silsuwan. All rights reserved.
//

import UIKit

class VerifyUserViewController: UIViewController {
    
    @IBOutlet weak var usernamePasswordView: UIView!
    
    @IBOutlet weak var usernameTextField: PaddingTextfiled!
    
    @IBOutlet weak var passwordTextField: PaddingTextfiled!
    
    @IBOutlet weak var verifyUserButton: UIButton!
    
    let lightGrayColor = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernamePasswordView.setBorderRadius(radius: 5)
        usernameTextField.setBorderRadius(radius: 5)
        usernameTextField.setBorderColor(color:lightGrayColor )
        passwordTextField.setBorderRadius(radius: 5)
        passwordTextField.setBorderColor(color: lightGrayColor)
        verifyUserButton.setBorderRadius(radius: 5)
    }

    @IBAction func closeVeridyUserView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
}
