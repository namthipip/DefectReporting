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
import ObjectMapper
import IQKeyboardManagerSwift
import SkyFloatingLabelTextField

class DefectAddDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var defectImg: UIImageView!
    
    @IBOutlet weak var dueDateTxt: UITextField!
    
    @IBOutlet weak var descriptionTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var expectedResultTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var typeTxt: SkyFloatingLabelTextField!
    
    @IBOutlet weak var priorityTxt: SkyFloatingLabelTextField!
    
    @IBOutlet weak var attachmentLabel: UILabel!
    
    @IBOutlet weak var videoPreviewLayer: UIView!
    
    @IBOutlet weak var attachmentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var severityTxt: SkyFloatingLabelTextField!
    
    @IBOutlet weak var projectTxt: SkyFloatingLabelTextField!
    
    @IBOutlet weak var reportDefectButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var submitSuccessView: UIView!
    
    @IBOutlet weak var sendAttachmentButton: UIButton!
    
    @IBOutlet weak var reportedLabel: UILabel!
    
    @IBOutlet weak var reporterButton: UIButton!
    
    var reporterID: String = ""
    
    var drawImg:UIImage?
    
    var datePicker:UIDatePicker!
    
    var activeField: UITextField?
    
    var player: AVPlayer!
    
    var avpController = AVPlayerViewController()
    
    var videoURL:URL?
    
    var viewLoading:UIView = UIView()
    
    var activityIndicator = UIActivityIndicatorView()
    
    var attributeList:DefectAttributeEntity?
    
    var inputPicker = UIPickerView()
    
    var selectedType:Int = 1
    
    var selectedSeverity:Int = 1
    
    var selectedPriority:Int = 1
    
    var selectedProject:Int = 1
    
    var selectedDueDate:String = ""
    
    var needAttactment: Bool = true
    
    var sendAttachmentFlag: Bool = false {
        didSet {
            if sendAttachmentFlag {
                let checkmark = DefectRecordShareInstance.sharedInstance.getImageFromBundle(name:"check-mark")
                sendAttachmentButton.setBackgroundImage(checkmark, for: .normal)
            }else {
                sendAttachmentButton.setBackgroundImage(nil, for: .normal)
            }
        }
    }
    
    public init() {
        super.init(nibName: "DefectAddDetailViewController", bundle: Bundle(for: RecordTypeViewController.self))
        needAttactment = false
    }
    
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
        
        getDefectAttribute()
        
        defectImg.image = drawImg
        self.title = "Report Defect"
        setTextFieldInput()
        reportDefectButton.setBorderRadius(radius: 5)
        cancelButton.setBorderRadius(radius: 5)
        initialLoadingView()
        
        if let url = videoURL{
            self.player = AVPlayer(url: url)
            self.avpController = AVPlayerViewController()
            self.avpController.player = self.player
            avpController.view.frame = CGRect(x: 0, y: 0, width: videoPreviewLayer.frame.size.width, height: videoPreviewLayer.frame.size.height)
            self.addChildViewController(avpController)
            self.videoPreviewLayer.addSubview(avpController.view)
        }
        
        sendAttachmentButton.setBorderRadius(radius: 10)
        sendAttachmentButton.setBorderColor(color: UIColor.lightGray)
        
        
        if (UserDefaults.standard.object(forKey: "reporterName") != nil) {
            guard let username = UserDefaults.standard.object(forKey: "reporterName") as? String else {
                return
            }
            reportedLabel.text = "Reporter: " + username
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = DefectRecordShareInstance.sharedInstance.themeColor
        if !needAttactment {
            attachmentLabel.isHidden = true
            attachmentViewHeight.constant = 0
            videoPreviewLayer.needsUpdateConstraints()
        }
    }
  
    func initialLoadingView() {
        viewLoading.backgroundColor = UIColor.black
        viewLoading.alpha = 0.7
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.green
        activityIndicator.frame = CGRect(x: (self.navigationController?.view.frame.size.width)!/2 - 25, y: (self.navigationController?.view.frame.size.height)!/2 - 25, width: 50, height: 50)
        viewLoading.frame = UIScreen.main.bounds
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
    
    func showError() {
        let alertController = UIAlertController(title: "Error", message: "Cannot create new defect, Please try again later", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setTextFieldInput() {
        inputPicker.delegate = self
        inputPicker.dataSource = self
        typeTxt.delegate = self
        projectTxt.delegate = self
        projectTxt.inputView = inputPicker
        projectTxt.addRightView()
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
        let dateConvertFormat = DateFormatter()
        dateConvertFormat.dateFormat = "yyyy-MM-dd"
        selectedDueDate = dateConvertFormat.string(from: datePicker.date)
    }
    
    func getDefectAttribute(){
        showLoadingView()
        let url = URL(string: "https://defect-recorder.herokuapp.com/filter/")!
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            self.hideLoading()
            guard error == nil,let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    self.attributeList = Mapper<DefectAttributeEntity>().map(JSON: json["filters"] as! [String : Any])
                    print(json)
                    
                }
            }catch let (error) {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendAttachmentTapped(_ sender: Any) {
        sendAttachmentFlag = !sendAttachmentFlag
    }
    
    @IBAction func saveDefect(_ sender: Any) {
        self.view.endEditing(true)
        if (UserDefaults.standard.object(forKey: "reporterID") != nil) {
            guard let userID = UserDefaults.standard.object(forKey: "reporterID") as? Int else {
                return
            }
            reporterID = String(userID)
            callServiceCreateDefect()
        }else {
            let verifyUserView = VerifyUserViewController()
            verifyUserView.modalPresentationStyle = .overCurrentContext
            verifyUserView.delegate = self
            self.navigationController?.present(verifyUserView, animated: true, completion: {
                
            })

        }
        
    }
    
    func callServiceCreateDefect() {
        
        showLoadingView()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let systemVersion = UIDevice.current.systemVersion
        var parameters = [ "reporterID": reporterID,
                           "defectDesc": descriptionTextField.text!,
                           "expectedResult": expectedResultTextField.text!,
                           "appVersion": appVersion!,
                           "deviceOSVersion": systemVersion,
                           "dueDate": selectedDueDate,
                           "typeID": selectedType,
                           "statusID": "1",
                           "priorityID":selectedPriority,
                           "severityID": selectedSeverity,
                           "platformID": "1",
                           "projectID": selectedProject] as [String : Any]
        
        if let debugLogData = FileManager.default.contents(atPath: DefectRecordShareInstance.sharedInstance.getLogFilePath()) {
            if sendAttachmentFlag {
                parameters["debugLogData"] = debugLogData.base64EncodedString(options: .lineLength64Characters)
            }
        }
        
        if needAttactment {
            parameters["attachmentType"] = ((videoURL) != nil) ? "video":"image"
            parameters["attachmentData"] = getBase64String()
        }
        
        let url = URL(string: "https://defect-recorder.herokuapp.com/defect/")!
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
            guard error == nil,let data = data else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.gotoSuccessView()
                }else {
                    self.hideLoading()
                    self.showError()
                }
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
    
    @IBAction func changeReporterTapped(_ sender: Any) {
        let verifyUserView = VerifyUserViewController()
        verifyUserView.modalPresentationStyle = .overCurrentContext
        verifyUserView.delegate = self
        self.navigationController?.present(verifyUserView, animated: true, completion: {
            
        })
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
        }else if textField == typeTxt {
            typeTxt.text =  attributeList?.type[inputPicker.selectedRow(inComponent: 0)].name
            selectedType =  (attributeList?.type[inputPicker.selectedRow(inComponent: 0)].id)!
        }else if textField == severityTxt {
            severityTxt.text =  attributeList?.severity[inputPicker.selectedRow(inComponent: 0)].name
            selectedSeverity =  (attributeList?.severity[inputPicker.selectedRow(inComponent: 0)].id)!
        }else if textField == priorityTxt {
            priorityTxt.text =  attributeList?.priority[inputPicker.selectedRow(inComponent: 0)].name
            selectedPriority =  (attributeList?.priority[inputPicker.selectedRow(inComponent: 0)].id)!
        }else if textField == projectTxt {
            projectTxt.text =  attributeList?.project[inputPicker.selectedRow(inComponent: 0)].name
            selectedProject =  (attributeList?.project[inputPicker.selectedRow(inComponent: 0)].id)!
        }
    }
}

extension DefectAddDetailViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeField == typeTxt {
            return (attributeList?.type.count)!
        }else if activeField == severityTxt {
            return (attributeList?.severity.count)!
        }else if activeField == projectTxt {
            return (attributeList?.project.count)!
        }else {
            return (attributeList?.priority.count)!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeField == typeTxt {
            return attributeList?.type[row].name
        }else if activeField == severityTxt {
            return attributeList?.severity[row].name
        }else if activeField == projectTxt {
            return attributeList?.project[row].name
        }else {
            return attributeList?.priority[row].name
        }
    }
    
}

extension DefectAddDetailViewController: VerfifyUserDelegate {
    func verifyUserSuccess(userID: String, username: String) {
        DispatchQueue.main.async {
            self.reporterID = userID
            self.reportedLabel.text = "Reporter: " + username
        }
    }
}
