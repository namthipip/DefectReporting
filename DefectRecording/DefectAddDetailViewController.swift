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
    
    @IBOutlet weak var expextedResultTextView: UITextView!
    
    @IBOutlet weak var typeTxt: UITextField!
  
    @IBOutlet weak var priorityTxt: UITextField!
    
    @IBOutlet weak var videoPreviewLayer: UIView!
    
    @IBOutlet weak var severityTxt: UITextField!
    
    @IBOutlet weak var reportDefectButton: UIButton!
    
    @IBOutlet weak var typeView: UIView!
    
    @IBOutlet weak var severityView: UIView!
    
    @IBOutlet weak var priorityView: UIView!
    
    @IBOutlet weak var dueDateView: UIView!
    
    var drawImg:UIImage?
    
    var datePicker:UIDatePicker!
    
    var activeField: UITextField?
    
    var player: AVPlayer!
    
    var avpController = AVPlayerViewController()
    
    var videoURL:URL?
    
    var severityValue = ["Inconsequencial" , "Minor" , "Major" , "Critical" , "Blocking"]
    var priorityValue = ["Low" , "Medium" , "High"]
    var typeValue = ["UI" , "Service" , "Logic" , "Other"]
    
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
        setStyleView(views: [descriptionTextView,expextedResultTextView,typeView,severityView,priorityView,dueDateView])
        setInitialValue()

        if let url = videoURL{
            self.player = AVPlayer(url: url)
            self.avpController = AVPlayerViewController()
            self.avpController.player = self.player
            avpController.view.frame = videoPreviewLayer.frame
            self.addChildViewController(avpController)
            self.videoPreviewLayer.addSubview(avpController.view)
        }
        
    }
    
    func setStyleView(views:[UIView]){
        for view in views {
            view.setBorderRadius(radius: 3)
            view.setBorderColor(color: .lightGray)
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
        let submitComplete = SubmitSuccessViewController()
        submitComplete.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(submitComplete, animated: true, completion: {

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
