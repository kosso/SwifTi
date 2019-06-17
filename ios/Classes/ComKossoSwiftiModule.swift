//
//  ComKossoSwiftiModule.swift
//  swifti
//
//  Created by Kosso
//  Copyright (c) 2019 . All rights reserved.
//

import UIKit
import TitaniumKit
import Foundation


/**
 
 Titanium Swift Module Requirements
 ---
 
 1. Use the @objc annotation to expose your class to Objective-C (used by the Titanium core)
 2. Use the @objc annotation to expose your method to Objective-C as well.
 3. Method arguments always have the "[Any]" type, specifying a various number of arguments.
 Unwrap them like you would do in Swift, e.g. "guard let arguments = arguments, let message = arguments.first"
 4. You can use any public Titanium API like before, e.g. TiUtils. Remember the type safety of Swift, like Int vs Int32
 and NSString vs. String.
 
 */

@objc(ComKossoSwiftiModule)
class ComKossoSwiftiModule: TiModule {
    
    // settable 'var'
    public var testProperty: String = "initial test property"
    // read only 'let' constant
    public let anotherTestProperty: String = "this is another test property"
    
    public var myview : ComKossoSwiftiView = ComKossoSwiftiView()
    
    func moduleGUID() -> String {
        return "f1c42bef-1c8f-458d-8506-fec64a21a9bb"
    }
    
    override func moduleId() -> String! {
        return "com.kosso.swifti"
    }
    
    override func startup() {
        super.startup()
        NSLog("[INFO] module was loaded.. nslog.. ")
    }
    
    @objc(example:)
    func example(arguments: Array<Any>?) -> String {
        // do something interesting here...
        NSLog("[INFO] inside example func")
        // for now, just return this..
        return anotherTestProperty
    }
    
    @objc public var exampleProp: String {
        get {
            // Example property getter
            return testProperty
        }
        set {
            NSLog("[INFO] setting new exampleProp value.. ")
            // Example property setter
            testProperty = newValue
        }
    }
    
    @objc(hellothere:)
    public func hellothere(args: Array<Any>?) -> Void {
        NSLog("[INFO] ComKossoSwiftiModule.swift hellothere ... ")
        // Call the hello function in the view class?
        myview.hello(args:nil)
    }
}
