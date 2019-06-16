//
//  KossoDrawingTestView.swift
//  ComKossoSwifti
//
//  Created by Kosso on 16/06/2019.
//

// A test UIView which fills the view with a set of horizontal coloured bars

import UIKit

open class KossoDrawingTestView : UIView {

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
        
        var cumulativeValue:CGFloat = 0 // store a cumulative value in order to start each line after the last one
        for i in 0..<numberOfSegments {
            
            ctx!.setFillColor(colors[i]?.cgColor ?? UIColor.clear.cgColor) // set fill color to the given color if it's provided, else use clearColor
            ctx!.fill(CGRect(x:0, y:cumulativeValue*r.size.height, width:r.size.width, height:values[i]*r.size.height)) // fill that given segment
            
            cumulativeValue += values[i] // increment cumulative value
        }
    }
}
