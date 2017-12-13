//
//  DrawingViewController.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/18/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import UIKit
import CoreGraphics

class DrawingViewController: UIViewController {
    
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var tempImgView: UIImageView!
    
    @IBOutlet weak var brushColorBtn: UIButton!
    @IBOutlet weak var brushWidthSlider: UISlider!
    @IBOutlet weak var viewBrushColor: UIView!
    @IBOutlet weak var colorRedBtn: UIButton!
    @IBOutlet weak var colorBlueBtn: UIButton!
    @IBOutlet weak var colorGreenBtn: UIButton!
    @IBOutlet weak var colorOrangeBtn: UIButton!
    @IBOutlet weak var colorPurpleBtn: UIButton!
    @IBOutlet weak var topViewBrushColorConstrain: NSLayoutConstraint!
    var lastPoint = CGPoint.zero
//    var red: CGFloat = 255.0
//    var green: CGFloat = 0.0
//    var blue: CGFloat = 0.0
    var stokeColor = UIColor.red
    var brushWidth: CGFloat = 5.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var eraseMode = false
    
    var screenShotImg:UIImage!
    
    public init(image:UIImage){
        super.init(nibName: "DrawingViewController", bundle: Bundle(for: RecordTypeViewController.self))
        screenShotImg = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialUI()
        
    }
    
    func initialUI(){
        mainImgView.image = screenShotImg
        tempImgView.image = screenShotImg
        brushColorBtn.backgroundColor = stokeColor
        brushWidthSlider.value = 5.0;
        setCornerRadius(buttonList: [brushColorBtn,colorRedBtn,colorBlueBtn,colorGreenBtn,colorOrangeBtn,colorPurpleBtn])
        
    }
    
    func setCornerRadius(buttonList:[UIButton]){
        for button in buttonList {
            button.layer.cornerRadius = 15.0
            button.layer.masksToBounds = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
    }
    
    @IBAction func backAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gotoDefectDetailView(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(tempImgView.frame.size, false, 0.0)
        mainImgView.image?.draw(in: CGRect(x: 0, y: 0, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height), blendMode: .normal, alpha: 1.0)
        tempImgView.image?.draw(in: CGRect(x: 0, y: 0, width: tempImgView.frame.size.width, height: tempImgView.frame.size.height), blendMode: .normal, alpha: opacity)
        tempImgView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let defectDetailView = DefectAddDetailViewController(image: tempImgView.image!)
        defectDetailView.navigationItem.hidesBackButton = true
        self.present(defectDetailView, animated: true, completion: nil)
    }
   
    @IBAction func resetDrawing(_ sender: Any) {
        tempImgView.image = screenShotImg
    }
    
    
    @IBAction func startDraw(_ sender: Any) {
        eraseMode = false
        brushWidth = 5
    }
    
    @IBAction func eraseDraw(_ sender: Any) {
        eraseMode = true
        brushWidth = 10
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext(){
            tempImgView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            
            // 2
            context.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
            
            // 3
            context.setLineCap(.round)
        
            if eraseMode {
                context.setBlendMode(.copy)
                context.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 0)
            }
            else{
                context.setBlendMode(.normal)
                context.setStrokeColor(stokeColor.cgColor)
            }
            
            context.setLineWidth(brushWidth)
            
            // 4
            context.strokePath()
            
            // 5
            tempImgView.image = UIGraphicsGetImageFromCurrentImageContext()
            tempImgView.alpha = opacity

        }
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
    @IBAction func changeBrushColor(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.viewBrushColor.isHidden = false
            self.topViewBrushColorConstrain.constant = -40
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func selectBrushColor(_ sender: Any) {
        let button = sender as! UIButton
        UIView.animate(withDuration: 0.3) {
            self.viewBrushColor.isHidden = true
            self.topViewBrushColorConstrain.constant = 0
            self.view.layoutIfNeeded()
            self.brushColorBtn.backgroundColor = button.backgroundColor
            self.stokeColor = self.brushColorBtn.backgroundColor!
        }
    }
    
    @IBAction func changeBrushWidth(_ sender: Any) {
        let slider = sender as! UISlider
        brushWidth = CGFloat(slider.value)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
