//
//  FloatingButtonController.swift
//  TextToSpeech
//
//  Created by Namthip Silsuwan on 10/10/2559 BE.
//  Copyright © 2559 Namthip Silsuwan. All rights reserved.
//

import UIKit

protocol ButtonWindowDelegate {
    func didTapButton() 
}

class FloatingButtonController: UIViewController {

    private(set) var button: UIButton!
    private(set) var timeLabel: UILabel!
    private let window = FloatingButtonWindow()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        window.windowLevel = CGFloat.greatestFiniteMagnitude
        window.isHidden = false
        window.rootViewController = self
    }
    
    override func loadView() {
        let view = UIView()
        let button = UIButton(type: .custom)
        //button.setTitle("Floating", for: .normal)
        //button.setTitleColor(UIColor.green, for: .normal)
        //button.backgroundColor = UIColor.white
        button.setImage(UIImage(named:"rec-button.png"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize.zero
        button.sizeToFit()
        let screenSize = UIScreen.main.bounds.size
        button.frame = CGRect(origin: CGPoint(x: screenSize.width / 2 - button.bounds.size.width / 2, y: screenSize.height - 65), size: CGSize(width: 50, height: 50))
        button.autoresizingMask = []
        view.addSubview(button)
        
        let timeLb = UILabel(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 50))
        timeLb.backgroundColor = UIColor.black
        timeLb.textColor = UIColor.white
        timeLb.alpha = 0.7
        timeLb.textAlignment = .center
        timeLb.text = "00:00:00"
        
        let viewStatusBar = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 20));
        viewStatusBar.backgroundColor = UIColor.black
        //viewStatusBar.alpha = 0.7
        //view.addSubview(viewStatusBar)
        view.addSubview(timeLb)
        
        self.view = view
        self.button = button
        self.timeLabel = timeLb
        window.button = button
        let panner = UIPanGestureRecognizer(target: self, action: #selector(FloatingButtonController.panDidFire(panner:)))
        button.addGestureRecognizer(panner)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //snapButtonToSocket()
    }
    
    func panDidFire(panner: UIPanGestureRecognizer) {
        let offset = panner.translation(in: view)
        panner.setTranslation(CGPoint.zero, in: view)
        var center = button.center
        center.x += offset.x
        center.y += offset.y
        button.center = center
        if panner.state == .ended || panner.state == .cancelled {
            UIView.animate(withDuration: 0.3) {
                //self.snapButtonToSocket()
            }
        }
    }
    
    func keyboardDidShow(note: NSNotification) {
        window.windowLevel = 0
        window.windowLevel = CGFloat.greatestFiniteMagnitude
    }
    
    private func snapButtonToSocket() {
        var bestSocket = CGPoint.zero
        var distanceToBestSocket = CGFloat.infinity
        let center = button.center
        for socket in sockets {
            let distance = hypot(center.x - socket.x, center.y - socket.y)
            if distance < distanceToBestSocket {
                distanceToBestSocket = distance
                bestSocket = socket
            }
        }
        button.center = bestSocket
    }
    
    private var sockets: [CGPoint] {
        let buttonSize = button.bounds.size
        let rect = view.bounds.insetBy(dx: 4 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
        let sockets: [CGPoint] = [
            CGPoint(x: rect.minX, y: rect.minY),
            CGPoint(x: rect.minX, y: rect.maxY),
            CGPoint(x: rect.maxX, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.maxY),
            CGPoint(x: rect.midX, y: rect.midY)
        ]
        return sockets
    }
    
    func showFloatingBtn(needShow:Bool){
        if needShow {
            button.isHidden = false
            timeLabel.isHidden = false
        }
        else{
            button.isHidden = true
            timeLabel.isHidden = true
        }
    }
    
    func updateRecordTime(timeStr:String){
        self.timeLabel.text = timeStr
    }
}
