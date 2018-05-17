//
//  VerifyUserViewController.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 4/19/2561 BE.
//  Copyright © 2561 Namthip Silsuwan. All rights reserved.
//

import UIKit

protocol VerfifyUserDelegate: class {
    func verifyUserSuccess(userID: String, username: String)
}

class VerifyUserViewController: UIViewController {
    
    @IBOutlet weak var usernamePasswordView: UIView!
    
    @IBOutlet weak var usernameTextField: PaddingTextfiled!
    
    @IBOutlet weak var passwordTextField: PaddingTextfiled!
    
    @IBOutlet weak var verifyUserButton: UIButton!
    
    @IBOutlet weak var saveReporterButton: UIButton!
    
    let lightGrayColor = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1.0)
    
    var viewLoading:UIView = UIView()
    
    var activityIndicator = UIActivityIndicatorView()
    
    weak var delegate: VerfifyUserDelegate?
    
    var saveUser: Bool = true {
        didSet {
            if saveUser {
                saveReporterButton.setBackgroundImage(UIImage(named: "check-mark"), for: .normal)
            }else {
                saveReporterButton.setBackgroundImage(nil, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoadingView()
        usernamePasswordView.setBorderRadius(radius: 5)
        usernameTextField.setBorderRadius(radius: 5)
        usernameTextField.setBorderColor(color:lightGrayColor )
        passwordTextField.setBorderRadius(radius: 5)
        passwordTextField.setBorderColor(color: lightGrayColor)
        verifyUserButton.setBorderRadius(radius: 5)
        saveReporterButton.setCornerCircle()
        saveReporterButton.setBorderColor(color: lightGrayColor)
    }

    @IBAction func saveReporterUserButton(_ sender: Any) {
        saveUser = !saveUser
    }
    
    @IBAction func verifyUserTapped(_ sender: Any) {
        showLoadingView()
        let url = URL(string: "https://defect-recorder.herokuapp.com/user/login")!
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters = ["username": usernameTextField.text!,
                         "password": passwordTextField.text!]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            print(response)
            guard error == nil,let data = data else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.hideLoading()
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print(json)
                            if let userData = json["user"] as? [String : Any] {
                                UserDefaults.standard.set(userData["userID"]!, forKey: "reporterID")
                                UserDefaults.standard.set(userData["username"]!, forKey: "reporterName")
                                UserDefaults.standard.synchronize()
                                self.delegate?.verifyUserSuccess(userID: String(userData["userID"] as! Int), username: userData["username"] as! String)
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                        }
                    }catch let (error) {
                        print(error.localizedDescription)
                    }
                }else {
                    self.hideLoading()
                    self.showError()
                }
            }
            
            
        }
        task.resume()
    }
    
    @IBAction func closeVeridyUserView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showLoadingView() {
        self.view.addSubview(viewLoading)
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.viewLoading.removeFromSuperview()
        }
    }
    
    func initialLoadingView() {
        viewLoading.backgroundColor = UIColor.black
        viewLoading.alpha = 0.7
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.green
        activityIndicator.frame = CGRect(x: (self.view.frame.size.width)/2 - 25, y: (self.view.frame.size.height)/2 - 25, width: 50, height: 50)
        viewLoading.frame = UIScreen.main.bounds
        viewLoading.addSubview(activityIndicator)
    }
   
    func showError() {
        let alertController = UIAlertController(title: "Error", message: "Username or Password invalid", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
