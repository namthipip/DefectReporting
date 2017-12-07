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
    
    @IBOutlet weak var videoPreviewLayer: UIView!
    
    var drawImg:UIImage?

    let priorityValue:[Int] = [0,5,10]
    
    var datePicker:UIDatePicker!
    
    var activeField: UITextField?
    
    var player: AVPlayer!
    
    var avpController = AVPlayerViewController()
    
    var videoURL:URL?
    
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
        
        let keyboardToolbar = UIToolbar()
        let dueDateToolbar = UIToolbar()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self.view, action: #selector(UIView.endEditing(_:)))
        
        keyboardToolbar.items = [flexBarButton,doneBarButton]
        descripTxt.inputAccessoryView = keyboardToolbar
        
        let doneDateBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self, action: #selector(self.didEnterDuedate))
        
        dueDateToolbar.items = [flexBarButton,doneDateBarButton]
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
    
        dueDateTxt.inputView = datePicker
        dueDateTxt.inputAccessoryView = dueDateToolbar
        
        setupToolbar(toolbars: [keyboardToolbar,dueDateToolbar])
        
        
        dueDateTxt.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageView.image = #imageLiteral(resourceName: "shop-dropdown")
        dueDateTxt.rightView = imageView
        
        dueDateTxt.delegate = self
        descripTxt.delegate = self
        
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setGradientSlider(slider: prioritySlider)
        //tickMarkViewForSlider(slider: prioritySlider)
    }
    
    func setGradientSlider(slider:UISlider) {
        
        print("slider width = \(slider.frame.width)")
        let tgl = CAGradientLayer()
        let frame = CGRect(x: 0, y: 0, width: slider.frame.width, height: 5)
        tgl.frame = frame
        tgl.colors = [UIColor.green.cgColor, UIColor.yellow.cgColor,UIColor.red.cgColor]
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
    
    func tickMarkViewForSlider(slider:UISlider){
        let tick = priorityValue.count
        var offsetOffset = (tick < 10) ? 1.7 : 1.1
        offsetOffset = (tick > 10) ? 0 : offsetOffset
        let offset = slider.frame.width / CGFloat(priorityValue.count - 1)
        var xPos:CGFloat = 0.0
        
        for i in stride(from: 0, to: tick, by: 1){
                let tick = UIView(frame: CGRect(x: xPos, y: 15, width: 1, height: 5))
                tick.backgroundColor = UIColor.lightGray
//                tick.layer.shadowColor = UIColor.white.cgColor
//                tick.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//                tick.layer.shadowOpacity = 1.0
//                tick.layer.shadowRadius = 0.0
                slider.addSubview(tick)
                xPos += offset
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = DefectRecordShareInstance.sharedInstance.themeColor
    }
    
    
    func priorityChange(slider:UISlider) {
        let index = Int(slider.value + 0.5)
        slider.setValue(Float(index), animated: false)
        let numberSlider = priorityValue[index]
//        print("sliderIndex:\(Int(index))")
//        print("number: \(numberSlider)")
        
    }
    
    func didEnterDuedate(){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        dueDateTxt.text = dateFormat.string(from: datePicker.date)
        dueDateTxt.resignFirstResponder()
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
    
//    func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
    
    @IBAction func saveDefect(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.dismiss(animated: true, completion: nil)
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
