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
    
    @IBOutlet weak var prioritySlider: UISlider!
    
    @IBOutlet weak var dueDateTxt: UITextField!
    
    @IBOutlet weak var descripTxt: UITextField!
    
    @IBOutlet weak var expectedTxt: UITextField!
    
    @IBOutlet weak var videoPreviewLayer: UIView!
    
    @IBOutlet weak var severityTxt: UITextField!
    
    @IBOutlet weak var checkboxUI: UIButton!
    
    @IBOutlet weak var checkboxFunctional: UIButton!
    
    var drawImg:UIImage?

    let priorityValue:[Int] = [0,5,10]
    
    var datePicker:UIDatePicker!
    
    var activeField: UITextField?
    
    var player: AVPlayer!
    
    var avpController = AVPlayerViewController()
    
    var videoURL:URL?
    
    var severityValue = ["Inconsequencial" , "Minor" , "Major" , "Critical" , "Blocking"]
    
    var severityPicker = UIPickerView()
    
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
        self.title = "Defect Detail"
        let numOfSteps = Float(priorityValue.count - 1)
        prioritySlider.minimumValue = 0
        prioritySlider.maximumValue = numOfSteps
        prioritySlider.isContinuous = true
        prioritySlider.value = 0
        prioritySlider.addTarget(self, action: #selector(self.priorityChange(slider:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        setupDueDatetextfield()
        
        checkboxUI.setCornerCircle()
        checkboxFunctional.setCornerCircle()
        
        
        if let url = videoURL{
            self.player = AVPlayer(url: url)
            self.avpController = AVPlayerViewController()
            self.avpController.player = self.player
            avpController.view.frame = videoPreviewLayer.frame
            self.addChildViewController(avpController)
            self.videoPreviewLayer.addSubview(avpController.view)
        }
        
    }
    
    func setupToolbar(toolbars:[UIToolbar]){
        for toolbar in toolbars {
            toolbar.sizeToFit()
            toolbar.backgroundColor = UIColor.clear
            toolbar.isTranslucent = false
            toolbar.tintColor = DefectRecordShareInstance.sharedInstance.themeColor
        }
    }
    
    func setupDueDatetextfield(){
        let keyboardToolbar = UIToolbar()
        let dueDateToolbar = UIToolbar()
        let severityToolbar = UIToolbar()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self.view, action: #selector(UIView.endEditing(_:)))
        
        keyboardToolbar.items = [flexBarButton,doneBarButton]
        descripTxt.inputAccessoryView = keyboardToolbar
        expectedTxt.inputAccessoryView = keyboardToolbar
        
        let doneDateBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                                target: self, action: #selector(self.didEnterDuedate))
        
        dueDateToolbar.items = [flexBarButton,doneDateBarButton]
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        dueDateTxt.inputView = datePicker
        dueDateTxt.inputAccessoryView = dueDateToolbar
        dueDateTxt.addRightView()
        
        let doneSeverityBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                                target: self, action: #selector(self.didEnterSeverity))
        
        severityToolbar.items = [flexBarButton,doneSeverityBarButton]
        severityTxt.inputAccessoryView = severityToolbar
        severityTxt.addRightView()
        severityTxt.inputView = severityPicker
        severityPicker.delegate = self
        
        setupToolbar(toolbars: [keyboardToolbar,dueDateToolbar,severityToolbar])
        
        dueDateTxt.delegate = self
        descripTxt.delegate = self
        severityTxt.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setGradientSlider(slider: prioritySlider)
    }
    
    func setGradientSlider(slider:UISlider) {
        let tgl = CAGradientLayer()
        let frame = CGRect(x: 0, y: 0, width: slider.frame.width, height: 5)
        tgl.frame = frame
        
        tgl.colors = [UIColor(red: 255.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.2).cgColor , UIColor(red: 255.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6).cgColor ,UIColor(red: 255.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor]
        tgl.startPoint = CGPoint(x: 0.0, y:  1.0)
        tgl.endPoint = CGPoint(x: 1.0, y:  1.0)
        
        UIGraphicsBeginImageContextWithOptions(tgl.frame.size, tgl.isOpaque, 0.0);
        tgl.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let trackImg = image?.resizableImage(withCapInsets: UIEdgeInsets.zero)
        slider.setMinimumTrackImage(trackImg, for: .normal)
        slider.setMaximumTrackImage(trackImg, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = DefectRecordShareInstance.sharedInstance.themeColor
    }
    
    
    func priorityChange(slider:UISlider) {
        let index = Int(slider.value + 0.5)
        slider.setValue(Float(index), animated: false)        
    }
    
    func didEnterDuedate(){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        dueDateTxt.text = dateFormat.string(from: datePicker.date)
        dueDateTxt.resignFirstResponder()
    }
    
    func didEnterSeverity(){
        severityTxt.resignFirstResponder()
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        //let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        if activeField != nil
        {
            if (!aRect.contains(activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
        
        
    }

    
    func keyboardWillHide(notification: NSNotification)
    {
        //Once keyboard disappears, restore original position
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        //let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = true
        
    }
    
    
    @IBAction func selectDefectType(_ sender: Any) {
        let checkBox = sender as! UIButton
        checkboxFunctional.setBackgroundImage(nil, for: .normal)
        checkboxUI.setBackgroundImage(nil, for: .normal)
        let radioOn = DefectRecordShareInstance.sharedInstance.getImageFromBundle(name:"radio-on-button")
        checkBox.setBackgroundImage(radioOn, for: .normal)
        
    }
    
    @IBAction func saveDefect(_ sender: Any) {
        self.view.endEditing(true)
//        let submitComplete = SubmitSuccessViewController()
//        submitComplete.modalPresentationStyle = .overCurrentContext
//        self.navigationController?.present(submitComplete, animated: true, completion: {
//
//        })
        let activityItem = URL(fileURLWithPath: DefectRecordShareInstance.sharedInstance.getFilePath())
        let activityVc = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
        self.present(activityVc, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DefectAddDetailViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
}

extension DefectAddDetailViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return severityValue.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return severityValue[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        severityTxt.text = severityValue[row]
    }

    
}
