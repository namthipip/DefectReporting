//
//  DefectAddDetailViewController.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/18/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class DefectAddDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var defectImg: UIImageView!
    
    @IBOutlet weak var dueDateTxt: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var expectedResultTextView: UITextView!
    
    @IBOutlet weak var typeTxt: UITextField!
    
    @IBOutlet weak var priorityTxt: UITextField!
    
    @IBOutlet weak var videoPreviewLayer: UIView!
    
    @IBOutlet weak var severityTxt: UITextField!
    
    @IBOutlet weak var reportDefectButton: UIButton!
    
    @IBOutlet weak var typeView: UIView!
    
    @IBOutlet weak var severityView: UIView!
    
    @IBOutlet weak var priorityView: UIView!
    
    @IBOutlet weak var dueDateView: UIView!
    
    @IBOutlet weak var submitSuccessView: UIView!
    
    var drawImg:UIImage?
    
    var datePicker:UIDatePicker!
    
    var activeField: UITextField?
    
    var player: AVPlayer!
    
    var avpController = AVPlayerViewController()
    
    var videoURL:URL?
    
    var severityValue = ["Inconsequencial" , "Minor" , "Major" , "Critical" , "Blocking"]
    var priorityValue = ["Low" , "Medium" , "High"]
    var typeValue = ["UI" , "Service" , "Logic" , "Other"]
    
    var viewLoading:UIView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    var inputPicker = UIPickerView()
    
    public init(image:UIImage){
        super.init(nibName: "DefectAddDetailViewController", bundle: Bundle(for: RecordTypeViewController.self))
        drawImg = image
    }
    
    public init(videoUrl:URL){
        super.init(nibName: "DefectAddDetailViewController", bundle: Bundle(for: RecordTypeViewController.self))
        videoURL = videoUrl
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defectImg.image = drawImg
        self.title = "Report Defect"
        setTextFieldInput()
        reportDefectButton.setBorderRadius(radius: 5)
        setStyleView(views: [descriptionTextView,expectedResultTextView,typeView,severityView,priorityView,dueDateView])
        setInitialValue()
        initialLoadingView()
        
        if let url = videoURL{
            self.player = AVPlayer(url: url)
            self.avpController = AVPlayerViewController()
            self.avpController.player = self.player
            avpController.view.frame = CGRect(x: 0, y: 0, width: videoPreviewLayer.frame.size.width, height: videoPreviewLayer.frame.size.height)
            self.addChildViewController(avpController)
            self.videoPreviewLayer.addSubview(avpController.view)
        }
        
    }
    
    func initialLoadingView() {
        viewLoading.backgroundColor = UIColor.black
        viewLoading.alpha = 0.7
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.green
        activityIndicator.frame = CGRect(x: (self.navigationController?.view.frame.size.width)!/2 - 25, y: (self.navigationController?.view.frame.size.height)!/2 - 25, width: 50, height: 50)
        viewLoading.frame = view.frame
        viewLoading.addSubview(activityIndicator)
    }
    
    func showLoadingView() {
        self.navigationController?.view.addSubview(viewLoading)
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.viewLoading.removeFromSuperview()
        }
    }
    
    func gotoSuccessView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0, animations: {
                self.activityIndicator.alpha = 0.0
                self.activityIndicator.removeFromSuperview()
            }, completion: { (complete) in
                UIView.animate(withDuration: 2.0, animations: {
                    self.submitSuccessView.alpha = 1.0
                    self.viewLoading.addSubview(self.submitSuccessView)
                }, completion: { (complete) in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                })
                
                
            })
        }
    }
    
    func setStyleView(views:[UIView]){
        for view in views {
            view.setBorderRadius(radius: 3)
            view.setBorderColor(color: UIColor(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1.0))
        }
    }
    
    func setInitialValue() {
        severityTxt.text = severityValue[0]
        priorityTxt.text = priorityValue[0]
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        dueDateTxt.text = dateFormat.string(from: Date())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = DefectRecordShareInstance.sharedInstance.themeColor
    }
    
    func setTextFieldInput() {
        inputPicker.delegate = self
        inputPicker.dataSource = self
        typeTxt.delegate = self
        typeTxt.inputView = inputPicker
        typeTxt.addRightView()
        severityTxt.inputView = inputPicker
        severityTxt.delegate = self
        severityTxt.addRightView()
        priorityTxt.inputView = inputPicker
        priorityTxt.delegate = self
        priorityTxt.addRightView()
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        dueDateTxt.inputView = datePicker
        dueDateTxt.delegate = self
        dueDateTxt.addRightView()
    }
    
    func didEnterDuedate() {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        dueDateTxt.text = dateFormat.string(from: datePicker.date)
        dueDateTxt.resignFirstResponder()
    }
    
    @IBAction func saveDefect(_ sender: Any) {
        self.view.endEditing(true)
        callServiceCreateDefect()
    }
    
    func callServiceCreateDefect() {
        
        showLoadingView()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let systemVersion = UIDevice.current.systemVersion
        
        let parameters = [ "reporter": "namthip.si",
                           "defectDesc": descriptionTextView.text!,
                           "expectedResult": expectedResultTextView.text!,
                           "appVersion": appVersion!,
                           "deviceOSVersion": systemVersion,
                           "attachmentType": ((videoURL) != nil) ? "video":"image",
                           "attachmentData": getBase64String(),
                           "dueDate": dueDateTxt.text!,
                           "typeID": "2",
                           "statusID": "1",
                           "priorityID":"1",
                           "severityID": "1",
                           "platformID": "1",
                           "projectID": "1"] as [String : Any]
        
        let url = URL(string: "https://defect-recorder.herokuapp.com/defect/createDefect")!
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            print(response)
            //self.hideLoading()
            self.gotoSuccessView()
            guard error == nil,let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                }
            }catch let (error) {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    func getBase64String() -> String {
        if let url = videoURL{
            guard let attachmentData = try? Data(contentsOf: url) else {
                return ""
            }
            return attachmentData.base64EncodedString(options: .lineLength64Characters)
        }else {
            let attachmentData = UIImagePNGRepresentation(defectImg.image!)
            return attachmentData!.base64EncodedString(options: .lineLength64Characters)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension DefectAddDetailViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        inputPicker.reloadAllComponents()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        if textField == dueDateTxt {
            didEnterDuedate()
        }
    }
    
}

extension DefectAddDetailViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeField == typeTxt {
            return typeValue.count
        }else if activeField == severityTxt {
            return severityValue.count
        }else {
            return priorityValue.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeField == typeTxt {
            return typeValue[row]
        }else if activeField == severityTxt {
            return severityValue[row]
        }else {
            return priorityValue[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeField == typeTxt {
            typeTxt.text = typeValue[row]
        }else if activeField == severityTxt {
            severityTxt.text = severityValue[row]
        }else {
            priorityTxt.text = priorityValue[row]
        }
        
    }
    
    
}
