//
//  ComKossoSwiftiViewProxy.swift
//  swifti
//
//  Created by Kosso
//  Copyright (c) 2019
//

// THIS MODULE SERVES LITTLE OTHER PURPOSE THAN TO LEARN HOW TO DO THINGS (or not!)


// It will create a View and place an old Siri-like wave animtation inside it.
// It also shows how to create more view classes and add them.
// Some basic microphone monitoring has also been added to attempt to use the audio power levels to adjust the wave amplitudes.
// To do... learn how to use the array of amplitude values to draw and update a 'graph'...


// learn more from this : https://github.com/appcelerator-modules/titanium-onboarding/blob/master/ios/Classes/TiOnboardingView.swift

// https://github.com/stefanceriu/SCSiriWaveformView
// https://timrichardson.co/2015/02/calling-objective-c-from-swift/
// https://timrichardson.co/2015/02/microphone-input-wave-like-siri-using-swift/


import UIKit
import TitaniumKit

import AVFoundation

@objc(ComKossoSwiftiViewProxy)
public class ComKossoSwiftiViewProxy : TiViewProxy {
    
    // in progress..
    var amplitudeGraphView:AmplitudeGraphView!
    
    // Testing some coloured bars...
    var kossoDrawingTestView:KossoDrawingTestView!
    
    // The (old) Siri-Wave...
    var waveformView:SwiftSiriWaveformView!

    var timer:Timer?
    var change:CGFloat = 0.01
    var running:Bool = false

    // Used for updating the waves
    var displayLink:CADisplayLink!
    
    // For microphone monitoring. (Doesn't actually record anything)
    var recorder:AVAudioRecorder!
    var recordingSession: AVAudioSession!
    
    // Test storage of values for drawing later..
    var amplitudeBuffer: Array<CGFloat> = Array()
    var bufferLength:Int = 32
    //var amplitudeBuffer: Array<Float> = Array(repeating: 0.0, count: 256)

    
    override init() {
        NSLog("[INFO] inside override init in ComKossoSwiftiViewProxy.swift ... ")
        super.init()
    }
    
    override public func _init(withProperties properties: [AnyHashable : Any]!) {
        NSLog("[INFO] inside override public func _init in ComKossoSwiftiViewProxy.swift ... ")
        let props = properties;
        super._init(withProperties: props)
        
        // Clear the background view colour..
        self.view.backgroundColor = .clear
    }
    
    
    public func setupRecorder() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            // Get permission to use the microphone and set the audio session
            if #available(iOS 10.0, *) {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
            } else {
                // Fallback on earlier versions
                recordingSession.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord, with:  [AVAudioSession.CategoryOptions.allowBluetooth])
            }
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        NSLog("[INFO] start recording.... ")
                        
                        self.startListeningRecorder()
                    } else {
                        // failed to record!
                        // do something...
                    }
                }
            }
        } catch {
            // failed to record!
            // do something...
        }
        
    }
    @objc func startListeningRecorder() {
        
        NSLog("[INFO] startListeningRecorder.... ")
        
        // send recording file nowhere, since we just want to monitor levels..
        let url:NSURL = NSURL(fileURLWithPath: "/dev/null")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatAppleLossless),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        do {
            recorder = try AVAudioRecorder(url: url as URL, settings: settings)
            recorder?.prepareToRecord()
            recorder?.isMeteringEnabled = true
            
            recorder?.record()
            // performs the updates
            displayLink = CADisplayLink(target: self, selector: #selector(self.updateMeters))
            displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
            
            NSLog("[INFO] recording to /dev/null should now be happening... with waves.... ")
            
        } catch {
            NSLog("[INFO] unable to start recording..... ")
            
            recorder?.stop()
            
            NSLog("[INFO] hmm ..... ")
            
        }
    }
    
    @objc func updateMeters() {
        
        recorder?.updateMeters()
        let normalizedValue:CGFloat = pow(10, CGFloat((recorder?.averagePower(forChannel: 0))!)/20)
        //let normalizedValue:CGFloat = pow(10, CGFloat(recorder.peakPower(forChannel: 0))/20)
        waveformView.amplitude = normalizedValue
        
        
        
        //NSLog("[INFO] updateMeters.... %@", normalizedValue)
        
        // add value to buffer
        amplitudeBuffer.append( normalizedValue )
        
       // amplitudeBuffer.append( Float(CGFloat(recorder.averagePower(forChannel: 0))).map(from: -160.0...0.0, to: 0.0...100.0) )
        // circular buffer?
        if(amplitudeBuffer.count > bufferLength){
            amplitudeBuffer.remove(at: 0)
        }
        
        amplitudeGraphView.values = amplitudeBuffer;
        
        
    }
    
    
    // Public methods accessible via the created Titanium View ...
    
    // SiriWave
    
    @objc(addSiriWave:)
    public func addSiriWave(args: Array<Any>?) {
        NSLog("[INFO] in proxy addSiriWave ... ")
        // SiriWaveformView test
        waveformView = SwiftSiriWaveformView(frame: CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height))
        waveformView.waveColor = .white
        waveformView.primaryLineWidth = 3.0
        waveformView.secondaryLineWidth = 1.0
        waveformView.backgroundColor = .clear
        waveformView.isUserInteractionEnabled = false
        self.view.addSubview(waveformView)
        
        //self.view.backgroundColor = .clear
        
        NSLog("[INFO] ComKossoSwiftiViewProxy.swift added waveformView ... \(String(describing: waveformView)) ")

        // call a single draw now
        waveformView.draw(CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height))
        
        
        /*
        // TESTING! (and learning!)...
        // Adds another view contanining some horizontal coloured bars..
        // only covers half the parent view width...
        kossoDrawingTestView = KossoDrawingTestView(frame: CGRect(x:0, y:0, width:self.view.bounds.width / 2, height:self.view.bounds.height))
        kossoDrawingTestView.colors = [
            UIColor(red: 1.0, green: 31.0/255.0, blue: 73.0/255.0, alpha: 0.6), // red
            UIColor(red:1.0, green: 138.0/255.0, blue: 0.0, alpha:0.6), // orange
            UIColor(red: 122.0/255.0, green: 108.0/255.0, blue: 1.0, alpha: 0.6), // purple
            UIColor(red: 0.0, green: 100.0/255.0, blue: 1.0, alpha: 0.6), // dark blue
            UIColor(red: 100.0/255.0, green: 241.0/255.0, blue: 183.0/255.0, alpha: 0.6), // green
            UIColor(red: 0.0, green: 222.0/255.0, blue: 1.0, alpha: 0.6) // blue
        ]
        kossoDrawingTestView.values = [0.15, 0.1, 0.35, 0.15, 0.1, 0.15]
        kossoDrawingTestView.isUserInteractionEnabled = false
        self.view.addSubview(kossoDrawingTestView)
        */
        
        
        // To do
        // Try and draw a grapth from the array of amplitude values...
        amplitudeGraphView = AmplitudeGraphView(frame: CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height))
        
        //amplitudeGraphView.values = [0.25, 0.21, 0.15, 0.15, 0.1, 0.15]
        amplitudeGraphView.isUserInteractionEnabled = false
        self.view.addSubview(amplitudeGraphView)
        
    }

    // Get current array of amplitude values to try and draw a graph or something...
    @objc(_getBuffer:)
    public func _getBuffer(args: Array<Any>?) -> Array<CGFloat>{
        return amplitudeBuffer
    }
    
    // Start animating the waves
    @objc(startSiriWave:)
    public func startSiriWave(args: Array<Any>?) {
        timer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshSiriWaveView(_:)), userInfo: nil, repeats: true)
        running = true
        
        setupRecorder()
        
    }
    // Stop animating the waves
    @objc(stopSiriWave:)
    public func stopSiriWave(args: Array<Any>?) {
        timer?.invalidate()
        running = false
        // stop the recorder
        recorder?.stop()
        // stop the meter updates
        displayLink.invalidate()
        
    }
    // Animation test demo - fluctuates the current ampiltude value a bit...
    @objc internal func refreshSiriWaveView(_:Timer) {
        if waveformView.amplitude <= waveformView.idleAmplitude || waveformView.amplitude > 0.3 {
            self.change *= -0.3
        }
        waveformView.amplitude += self.change
    }
    
    // Test functon to animate the values up and down for demo
    //    @objc internal func refreshSiriWaveView(_:Timer) {
    //        if waveformView.amplitude <= waveformView.idleAmplitude || waveformView.amplitude > 1.0 {
    //            self.change *= -1.0
    //        }
    //        waveformView.amplitude += self.change
    //    }
    
    // Set the colour of the wave lines
    @objc(_setBarsColor:)
    public func _setBarsColor(args: Array<Any>?) {
        NSLog("[INFO] ComKossoSwiftiViewProxy.swift _setWaveformColor \(String(describing: args?[0])) ")
        amplitudeGraphView.barColor = TiUtils.colorValue(args?[0])!.color
    }
    
    // Set the colour of the wave lines
    @objc(_setWaveformColor:)
    public func _setWaveformColor(args: Array<Any>?) {
        NSLog("[INFO] ComKossoSwiftiViewProxy.swift _setWaveformColor \(String(describing: args?[0])) ")
        waveformView.waveColor = TiUtils.colorValue(args?[0])!.color
    }
    // Set the width of the main wave line
    @objc(_setPrimaryLineWidth:)
    public func _setPrimaryLineWidth(args: Array<Any>?) {
        NSLog("[INFO] ComKossoSwiftiViewProxy.swift _setPrimaryLineWidth  \(String(describing: args?[0])) ")
        waveformView.primaryLineWidth = CGFloat( TiUtils.floatValue(args?[0]) )
    }
    // Set the width of the extra wave lines
    @objc(_setSecondaryLineWidth:)
    public func _setSecondaryLineWidth(args: Array<Any>?) {
        NSLog("[INFO] ComKossoSwiftiViewProxy.swift _setSecondaryLineWidth  \(String(describing: args?[0])) ")
        waveformView.secondaryLineWidth = CGFloat( TiUtils.floatValue(args?[0]) )
    }
    // Set the amplitude value
    @objc(_setAmplitude:)
    public func _setAmplitude(args: Array<Any>?) {
        // NSLog("[INFO] ComKossoSwiftiViewProxy.swift setAmplitude: \(String(describing: args?[0])) ")
        waveformView.amplitude = CGFloat( TiUtils.floatValue(args?[0]) )
    }
    // Sets the background colour of the parent view.
    @objc(_setBackgroundColor:)
    public func _setBackgroundColor(args: Array<Any>?) {
        NSLog("[INFO] ComKossoSwiftiViewProxy.swift _setBackgroundColor  \(String(describing: args?[0])) ")
        self.view.backgroundColor = TiUtils.colorValue(args?[0])?.color
    }
    
    @objc(isRunning:)
    public func isRunning(args: Array<Any>?) -> Bool {
        return running
    }
    
    // Test method
    @objc(helloproxy:)
    public func helloproxy(args: Array<Any>?) {
        NSLog("[INFO] ComKossoSwiftiViewProxy.swift helloproxy ...")
    }
}



// map value utility
// https://gist.github.com/ZevEisenberg/7ababb61eeab2e93a6d9
extension CGFloat {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        return result
    }
}

extension Double {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> Double {
        return Double(CGFloat(self).map(from: from, to: to))
    }
}

extension Float {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> Float {
        return Float(CGFloat(self).map(from: from, to: to))
    }
}
