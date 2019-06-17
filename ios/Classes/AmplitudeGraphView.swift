//
//  AmplitudeGraphView.swift
//  ComKossoSwifti
//
//  Created by Kosso on 16/06/2019.
//

// Draws bars across the screen of the circular buffer array of amplitude values while the recorder is running.

import UIKit

open class AmplitudeGraphView : UIView {
    
    var barsColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        // This means that when this property changes, the enclosed will be called.
        didSet {
            // A builtin iOS UIView method which triggers a redraw by calling the overridden 'draw' function below (used to be 'drawRect')
            self.setNeedsDisplay()
        }
    }
    
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
        let segWidth:CGFloat = (r.width / CGFloat(numberOfSegments)).rounded() // mmm.. pixels...
        
        for i in 0..<numberOfSegments {
            ctx!.setFillColor(barsColor.cgColor)
            // bars aligned to middle
            ctx!.fill(
                CGRect(
                    x: CGFloat(i) * segWidth,
                    y:(r.size.height - values[i] * r.size.height) / 2,
                    width:segWidth - 5.0,
                    height:values[i] * r.size.height
                )
            )
        }
    }
}
