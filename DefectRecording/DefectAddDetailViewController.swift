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
    
    let priorityValue:[Int] = [0,5,10]
    
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
        self.title = "Defect Detail"
        let numOfSteps = Float(priorityValue.count - 1)
        prioritySlider.minimumValue = 0
        prioritySlider.maximumValue = numOfSteps
        prioritySlider.isContinuous = true
        prioritySlider.value = 0
        prioritySlider.addTarget(self, action: #selector(self.priorityChange(slider:)), for: .valueChanged)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setGradientSlider(slider: prioritySlider)
        tickMarkViewForSlider(slider: prioritySlider)
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
        let tickDevider = (slider.maximumValue > 10 ) ? 10 : 1
        let tick = priorityValue.count//Int(slider.maximumValue) / tickDevider
        var offsetOffset = (tick < 10) ? 1.7 : 1.1
        offsetOffset = (tick > 10) ? 0 : offsetOffset
        let offset = slider.frame.width / 3/// CGFloat(tick) - CGFloat(offsetOffset)
        var xPos:CGFloat = 0.0
        
        for i in stride(from: 0, to: tick, by: 1){
//            if i == 0 {
//                xPos += offset + 5.25
//            }
//            else{
                let tick = UIView(frame: CGRect(x: xPos, y: 15, width: 2, height: 5))
                tick.backgroundColor = UIColor.lightGray
//                tick.layer.shadowColor = UIColor.white.cgColor
//                tick.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//                tick.layer.shadowOpacity = 1.0
//                tick.layer.shadowRadius = 0.0
                slider.addSubview(tick)
                xPos += offset
            //}
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
