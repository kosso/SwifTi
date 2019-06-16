//
//  AmplitudeGraphView.swift
//  ComKossoSwifti
//
//  Created by Kosso on 16/06/2019.
//

// A test UIView which fills the view with a set of horizontal coloured bars

import UIKit

open class AmplitudeGraphView : UIView {
    
    // Properties of this UIView
    
    
    var barColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        // This means that when this property changes, the enclosed will be called.
        didSet {
            // A builtin iOS UIView method which triggers a redraw by calling the overridden 'draw' function below (used to be 'drawRect')
            self.setNeedsDisplay()
        }
    }
    
    
    var colors : [UIColor?] = [UIColor?]() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// An array of CGFloat values to define how much of the view each segment occupies. Should add up to 1.0.
    var values : [CGFloat] = [CGFloat]() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // The 'draw' function used to be 'drawRect' and will be called each time self.setNeedsDisplay() is called.. which is called each time the values are 'didSet'.
    override open func draw(_ rect: CGRect) {
        
        let r = self.bounds // the view's bounds
        let numberOfSegments = values.count // number of segments to render
        
        let ctx = UIGraphicsGetCurrentContext() // get the current context
        
        let segWidth:CGFloat = (r.width / CGFloat(numberOfSegments)).rounded()
        
        
        //var cumulativeValue:CGFloat = 0 // store a cumulative value in order to start each line after the last one
        for i in 0..<numberOfSegments {
            
            //ctx!.setFillColor(colors[i]?.cgColor ?? UIColor.clear.cgColor)
            ctx!.setFillColor(barColor.cgColor)
            
            //ctx!.fill(CGRect(x:0, y:cumulativeValue*r.size.height, width:r.size.width, height:values[i]*r.size.height)) // fill that given segment
            
            
            ctx!.fill(CGRect(x: CGFloat(i) * segWidth, y:0, width:segWidth, height:values[i] * r.size.height))
            
            
            //cumulativeValue += values[i] // increment cumulative value
        }
    }
}
