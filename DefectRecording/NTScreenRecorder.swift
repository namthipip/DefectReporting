//
//  NTScreenRecorder.swift
//  DefectRecording
//
//  Created by Namthip Silsuwan on 6/26/2560 BE.
//  Copyright © 2560 Namthip Silsuwan. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

protocol NTScreenRecorderDelegate:class {
    
}

typealias videoCompletionBlock = () -> Void

class NTScreenRecorder: NSObject {
    
    var isRecording:Bool!
    weak var delegate:NTScreenRecorderDelegate?
    var videoURL:URL?
    var videoWriter:AVAssetWriter?
    var videoWriterInput:AVAssetWriterInput?
    var avAdaptor:AVAssetWriterInputPixelBufferAdaptor?
    var displayLink:CADisplayLink?
    var outputBufferPoolAuxAttributes:Dictionary<<#Key: Hashable#>, Any>?
    var firstTimeStamp:CFTimeInterval?
    var viewSize:CGSize?
    var scale:CGFloat?
    var rgbColorSpace:CGColorSpace
    var outputBufferPool:CVPixelBufferPool
    
    var render_queue:DispatchQueue?
    var append_pixelBuffer_queue:DispatchQueue?
    var frameRenderingSemaphore:DispatchSemaphore?
    var pixelAppendSemaphore:DispatchSemaphore?
    
    
    
    private static var shareInstance:NTScreenRecorder = {
        let share = NTScreenRecorder.init()
        return share
    }()
    
    private override convenience init() {
        self.init()
        viewSize = UIScreen.main.bounds.size
        scale = UIScreen.main.scale
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad && scale! > CGFloat(1.0) {
            scale = 1.0
        }
        isRecording = false
        append_pixelBuffer_queue = DispatchQueue(label:"NTScreenRecorder.append_queue")
        render_queue = DispatchQueue(label: "NTScreenRecorder.render_queue")
        render_queue?.setTarget(queue: DispatchQueue.global())
        frameRenderingSemaphore = DispatchSemaphore(value: 1)
        pixelAppendSemaphore = DispatchSemaphore(value: 1)
        
    }
    
    func startRecord() -> Bool{
        if !isRecording {
            setupWriter()
            isRecording = videoWriter?.status == AVAssetWriterStatus.writing
            displayLink = CADisplayLink(target: self, selector: #selector(self.writerVideoFrame))
            displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        }
        return isRecording
    }
    
    func stopRecord(completionHandler:@escaping (Bool) -> ()){
        if isRecording {
            isRecording = false
            displayLink?.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
            
        }
    }
    
    func setupWriter(){
        
    }
    
    func videoTransformForDeviceOrientation() -> CGAffineTransform{
        
    }
    
    func tempFileURL() -> URL{
        let outputPath = NSHomeDirectory().appending("tmp/screenCapture.mp4")
        removeTempFilePath(path: outputPath)
        return URL(fileURLWithPath: outputPath)
    }
    
    func removeTempFilePath(path:String){
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
//            if fileManager.removeItem(atPath: path) {
//                
//            }
        }
    }
    
    func completeRecordSession(completionHandler:@escaping () -> ()){
        render_queue?.async {
            self.append_pixelBuffer_queue?.sync {
                self.videoWriterInput?.markAsFinished()
                self.videoWriter?.finishWriting(completionHandler: {
                    DispatchQueue.main.async {
                        completionHandler()
                    }
                })
                
                if (self.videoURL != nil){
                    
                }
                else{
                    let library = ALAssetsLibrary()
                    library.writeVideoAtPath(toSavedPhotosAlbum: self.videoWriter?.outputURL, completionBlock: { (assetURL, error) in
                        if (error != nil){
                            print("Error copying video to camera roll: \(String(describing: error?.localizedDescription))")
                        }
                        else{
                            completionHandler()
                        }
                    })
                }
            }
        }
        
        
    }
    
    func writerVideoFrame(){
        if frameRenderingSemaphore?.signal() != 0 {
            return
        }
        render_queue?.async {
            if !(self.videoWriterInput?.isReadyForMoreMediaData)! {
                return
            }
            if(self.firstTimeStamp == nil){
                self.firstTimeStamp = self.displayLink?.timestamp
            }
            let elapsed:CFTimeInterval = (self.displayLink?.timestamp)! - self.firstTimeStamp!
            let time:CMTime = CMTime(seconds: elapsed, preferredTimescale: 1000)
            
            let pixelBuffer:CVPixelBuffer?
            let bitmapContext:CGContext = self.createPixelBufferAndBitmapContext(pixelBuffer: pixelBuffer!)
            DispatchQueue.main.sync {
                UIGraphicsPushContext(bitmapContext)
                for window in UIApplication.shared.windows{
                    window.drawHierarchy(in: CGRect(x: 0, y: 0, width: (self.viewSize?.width)!, height: (self.viewSize?.height)!), afterScreenUpdates: false)
                }
                UIGraphicsPopContext()
            }
            
            if self.pixelAppendSemaphore?.signal() == 0 {
                self.append_pixelBuffer_queue?.async {
                    let success = self.avAdaptor?.append(pixelBuffer!, withPresentationTime: time)
                    if (!success!) {
                        print("Warning: Unable to write buffer to video")
                    }
                    CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
                    __dispatch_semaphore_signal(self.pixelAppendSemaphore!)
                }
            }
            else{
                CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
                
            }
            
            __dispatch_semaphore_signal(self.frameRenderingSemaphore!)
        }
    }
    
    func cleanup(){
        avAdaptor = nil
        videoWriterInput = nil
        videoWriter = nil
        firstTimeStamp = 0
        outputBufferPoolAuxAttributes = nil
        
    }
    
    func createPixelBufferAndBitmapContext(pixelBuffer:UnsafeMutablePointer<CVPixelBuffer?>!) -> CGContext{
        
        CVPixelBufferPoolCreatePixelBuffer(nil, outputBufferPool, pixelBuffer)
        CVPixelBufferLockBaseAddress(pixelBuffer as! CVPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        var bitmapContext:UnsafeMutablePointer<CGContext?>!
        
        
        
        
    }

}
