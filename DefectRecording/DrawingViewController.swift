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

        mainImgView.image = screenShotImg
        tempImgView.image = screenShotImg
        let cancelBarBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "clear-button"), style: .plain, target: self, action: #selector(self.cancelDrawing))
        let nextBarBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "checked"), style: .plain, target: self, action: #selector(self.nextView))
        self.navigationItem.leftBarButtonItem = cancelBarBtn
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = nextBarBtn
        self.navigationItem.rightBarButtonItem?.tintColor = DefectRecordShareInstance.sharedInstance.themeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
    }
    
    func cancelDrawing(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func nextView(){
        let defectDetailView = DefectAddDetailViewController(image: tempImgView.image!)
        self.navigationController?.pushViewController(defectDetailView, animated: true)
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
        UIGraphicsBeginImageContext(view.frame.size)
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
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(tempImgView.frame.size)
        mainImgView.image?.draw(in: CGRect(x: 0, y: 0, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height), blendMode: .normal, alpha: 1.0)
        tempImgView.image?.draw(in: CGRect(x: 0, y: 0, width: tempImgView.frame.size.width, height: tempImgView.frame.size.height), blendMode: .normal, alpha: opacity)
        tempImgView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}