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
        button.setImage(#imageLiteral(resourceName: "rec-button"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize.zero
        button.sizeToFit()
        button.frame = CGRect(origin: CGPoint(x: view.frame.width / 2 - button.bounds.size.width / 2, y: view.frame.size.height - 20), size: CGSize(width: 50, height: 50))
        button.autoresizingMask = []
        view.addSubview(button)
        self.view = view
        self.button = button
        window.button = button
        let panner = UIPanGestureRecognizer(target: self, action: #selector(FloatingButtonController.panDidFire(panner:)))
        button.addGestureRecognizer(panner)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        snapButtonToSocket()
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
                self.snapButtonToSocket()
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
        }
        else{
            button.isHidden = true
        }
    }
}
