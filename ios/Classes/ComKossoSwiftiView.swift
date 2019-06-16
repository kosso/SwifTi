//
//  ComKossoSwiftiView.swift
//  swifti
//
//  Created by Kosso
//  Copyright (c) 2019


// WARNING : THIS IS LEARNING/DEVELOPMENT !!


import TitaniumKit
import UIKit


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
        // self.backgroundColor = .purple
    }
    
    
    override public func initializeState(){

        NSLog("[INFO] in initializeState... ")
        super.initializeState()
        self.initializeComKossoSwiftiView();
        
    }
    
    private func initializeComKossoSwiftiView() {
        
        NSLog("[INFO] initializeComKossoSwiftiView.. ")
       
        
    }
    
    // Test
    @objc(hello:)
    public func hello(args: Array<Any>?) {
        
        NSLog("[INFO] ComKossoSwiftiView.swift hello ... ")
        
    }
    

}
