//
//  ComKossoSwiftiView.swift
//  swifti
//
//  Created by Kosso
//  Copyright (c) 2019


// WARNING : THIS IS LEARNING/DEVELOPMENT !!

// learn more from this : https://github.com/appcelerator-modules/titanium-onboarding/blob/master/ios/Classes/TiOnboardingView.swift

// https://github.com/stefanceriu/SCSiriWaveformView
// https://timrichardson.co/2015/02/calling-objective-c-from-swift/
// https://timrichardson.co/2015/02/microphone-input-wave-like-siri-using-swift/




import TitaniumKit
import UIKit

import AVFoundation



@objc(ComKossoSwiftiView)
public class ComKossoSwiftiView : TiUIView {
    

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // hmmmm.....
    override public func frameSizeChanged(_ frame: CGRect, bounds: CGRect) {
        // self.backgroundColor = .green
        super.frameSizeChanged(frame, bounds: bounds)
    }
    
    
    private func setup() {
        // some defaults....?
        // NSLog("[INFO] in setup func. setting default blue background")
        // myview.backgroundColor = .blue
        // self.backgroundColor = .purple
    }
    
    
    override public func initializeState(){
        
        debugPrint("[DEBUG] in initializeState... ")
        
        super.initializeState()
        
        //setup()
        
        self.initializeComKossoSwiftiView();
        
    }
    
    private func initializeComKossoSwiftiView() {
        
        //debugPrint("in initializeComKossoSwiftiView... ")
        NSLog("[INFO] initializeComKossoSwiftiView.. ")
        
        // Test add a view
        // let vu = UIView();
        // vu.backgroundColor = .red
        // vu.layer.borderWidth = 2
        // vu.layer.borderColor = UIColor.white.cgColor
        // vu.frame = CGRect(x:40,y:40,width:60,height:30)
        // vu.isUserInteractionEnabled = false  // allows clickthough
        // self.addSubview(vu)
 
        
        
        /*
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
        // if #available(iOS 10.0, *) {
        // try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
        // } else {
        // session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord, with:  [AVAudioSession.CategoryOptions.allowBluetooth])
        // }
         
            if #available(iOS 10.0, *) {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
            } else {
                // Fallback on earlier versions
            }
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        NSLog("[INFO] start recording.... ")
                        
                        self.startRecording()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
        */
        
        
    }
    
    /*
    @objc func startRecording() {
        
        NSLog("[INFO] startRecording.... ")
        
        // send recording nowhere, since we just want to monitor levels..
        let url:NSURL = NSURL(fileURLWithPath: "/dev/null")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatAppleLossless),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        do {
            recorder = try AVAudioRecorder(url: url as URL, settings: settings)
            recorder.prepareToRecord()
            recorder.isMeteringEnabled = true
            
            recorder.record()
            
            let displayLink:CADisplayLink = CADisplayLink(target: self, selector: #selector(self.updateMeters))
            displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
            
             NSLog("[INFO] recording to /dev/null should now be happening... with waves.... ")
            
        } catch {
            NSLog("[INFO] unable to start recording..... ")

            recorder.stop()
            
             NSLog("[INFO] hmm ..... ")

        }
    }
    
    @objc func updateMeters() {
        
        recorder.updateMeters()
        let normalizedValue:CGFloat = pow(10, CGFloat(recorder.averagePower(forChannel: 0))/20)
        waveformView.amplitude = normalizedValue
        
        //NSLog("[INFO] updateMeters.... %@", normalizedValue)
        
        
    }
    
    */
    
    // Test
    @objc(hello:)
    public func hello(args: Array<Any>?) {
        
        NSLog("[INFO] ComKossoSwiftiView.swift hello ... ")
        
    }
    

}
