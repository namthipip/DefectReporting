//
//  DefectAddDetailViewController.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/18/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import UIKit

class DefectAddDetailViewController: UIViewController {

    @IBOutlet weak var defectImg: UIImageView!
    
    @IBOutlet weak var prioritySlider: UISlider!
    
    var drawImg:UIImage!
    
    let number:[Int] = [0,5,10]
    
    public init(image:UIImage){
        super.init(nibName: "DefectAddDetailViewController", bundle: Bundle(for: RecordTypeViewController.self))
        drawImg = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defectImg.image = drawImg
        
        let numOfSteps = Float(number.count - 1)
        prioritySlider.minimumValue = 0
        prioritySlider.maximumValue = numOfSteps
        prioritySlider.isContinuous = true
        prioritySlider.value = 0
        prioritySlider.addTarget(self, action: #selector(self.priorityChange(slider:)), for: .valueChanged)
        setSlider(slider: prioritySlider)
        //setGradientToSlider(slider: prioritySlider)
        
    }
    
    func setSlider(slider:UISlider) {
        
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
        
        //image?.resizableImage(withCapInsets: UIEdgeInsets.zero)
        
//        slider.setMinimumTrackImage(image, for: .normal)
//        slider.setMaximumTrackImage(image, for: .normal)
        
        let trackImg = image?.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        slider.setMinimumTrackImage(trackImg, for: .normal)
        slider.setMaximumTrackImage(trackImg, for: .normal)
        
    }
    
    func setGradientToSlider(slider:UISlider){
        
        let view = slider.subviews[0]
        let max_trackImageView = view.subviews[0]
        
        //setting gradient to max track image view.
        
        let max_trackGradient = CAGradientLayer()
        max_trackGradient.frame = max_trackImageView.frame
        max_trackGradient.colors = [UIColor.green.cgColor, UIColor.yellow.cgColor,UIColor.red.cgColor]
        max_trackGradient.startPoint = CGPoint(x: 0.0, y:  0.5)
        max_trackGradient.endPoint = CGPoint(x: 1.0, y:  0.5)
        
        view.layer.cornerRadius = 5.0
        max_trackImageView.layer.insertSublayer(max_trackGradient, at: 0)
        
         //Setting gradient to min track ImageView.
        let min_trackGradient = CAGradientLayer()
        let min_trackImageView = slider.subviews[1]
        min_trackGradient.frame = min_trackImageView.frame
        min_trackGradient.colors = [UIColor.green.cgColor, UIColor.yellow.cgColor,UIColor.red.cgColor]
        min_trackGradient.startPoint = CGPoint(x: 0.0, y:  0.5)
        min_trackGradient.endPoint = CGPoint(x: 1.0, y:  0.5)
        
        min_trackImageView.layer.cornerRadius = 5.0
        min_trackImageView.layer.insertSublayer(min_trackGradient, at: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = DefectRecordShareInstance.sharedInstance.themeColor
    }
    
    
    func priorityChange(slider:UISlider) {
        let index = Int(slider.value + 0.5)
        slider.setValue(Float(index), animated: false)
        let numberSlider = number[index]
        print("sliderIndex:\(Int(index))")
        print("number: \(numberSlider)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
