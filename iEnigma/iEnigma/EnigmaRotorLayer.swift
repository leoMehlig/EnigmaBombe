//
//  EnigmaRotorView.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/18/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

@IBDesignable
class EnigmaRotorLayer: CALayer {
    
    
    
    
    var crogs: Int = 23 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var lineWidth: CGFloat = 3 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var margin: CGFloat = 3 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var strokeColor: UIColor = Constants.Design.Colors.Text {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var fillColor: UIColor = Constants.Design.Colors.Foreground {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func drawInContext(ctx: CGContext!) {
        let points = gearWheelPointsForRect(bounds)
        if !points.inner.isEmpty && !points.outter.isEmpty {
            UIGraphicsPushContext(ctx)
            let path = UIBezierPath()
            path.moveToPoint(points.inner.first!)
            var isOutter = false
            for (idx, innerPoint) in enumerate(points.inner) {
                if idx >= points.outter.count { break }
                let outterPoint = points.outter[idx]
                if isOutter {
                    path.addLineToPoint(outterPoint)
                    path.addLineToPoint(innerPoint)
                    isOutter = false
                } else {
                    path.addLineToPoint(innerPoint)
                    path.addLineToPoint(outterPoint)
                    isOutter = true
                }
            }
            path.closePath()
            
            path.lineWidth = lineWidth
            strokeColor.setStroke()
            fillColor.setFill()
            
            path.stroke()
            path.fill()
            UIGraphicsPopContext()
        }
        super.drawInContext(ctx)
        
    }
   
    
    
    
    
    private func tanDeg(x: CGFloat) -> CGFloat {
        return tan(x /  CGFloat(180 / M_PI))
    }
    
    private func calcPoints(mA: CGFloat, mB: CGFloat, a: CGPoint, b: CGPoint) -> (CGPoint, CGPoint) {
        let x = (mB * b.x - mA * a.x + a.y - b.y) / (mB - mA)
        let x1 = 2 * a.x - x
        let y = -(mA * x1 - mA * a.x - a.y)
        let p1 = CGPoint(x: x, y: y)
        let p2 = CGPoint(x: x1, y: y)
        return (p1, p2)
    }
    
    private func gearWheelPointsForRect(rect: CGRect) -> (inner: [CGPoint], outter: [CGPoint]){
        let viewCenter = CGPoint(x: rect.midX, y: rect.midY)
        let outterRadius: CGFloat = min(rect.height / 2, rect.width / 2) - borderWidth - margin
        
        
        let innerRadius: CGFloat =  outterRadius - outterRadius / 10
        let points: Int
        if crogs < 10 {
            points = 10
        } else if crogs % 2 == 1 {
            points = crogs + 1
        } else {
            points = crogs
        }
        
        let innerA = CGPoint(x: viewCenter.x, y: viewCenter.y - innerRadius)
        let outterA = CGPoint(x: viewCenter.x, y: viewCenter.y - outterRadius)
        let angle = 360 / CGFloat(points)
        
        var innerPoints = [innerA]
        var outterPoints = [outterA]
        
        for i in 1...points/2 {
            let n = angle * CGFloat(i)
            if n >= 180 {
                innerPoints.append(CGPoint(x: viewCenter.x, y: viewCenter.y + innerRadius))
                outterPoints.append(CGPoint(x: viewCenter.x, y: viewCenter.y + outterRadius))
            } else {
                let angleA = tanDeg(-90 + ((180 - n) / 2))
                let angleB = tanDeg(90 - n)
                let p = calcPoints(angleA, mB: angleB, a: innerA, b: viewCenter)
                innerPoints.insert(p.0, atIndex: 0)
                innerPoints.append(p.1)
                let largeP = calcPoints(angleA, mB: angleB, a: outterA, b: viewCenter)
                outterPoints.insert(largeP.0, atIndex: 0)
                outterPoints.append(largeP.1)
            }
            
        }
        return (innerPoints, outterPoints)
    }
}
