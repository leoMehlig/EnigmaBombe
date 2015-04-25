//
//  BombeDrumLayer.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/25/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class BombeDrumLayer: CALayer {
    var highlighted = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var bColor: UIColor = Constants.Design.Colors.Text {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var letterBorderWidth: CGFloat = 10 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var bWidth: CGFloat = 3 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    //var upIdx = 0
   
    override func drawInContext(ctx: CGContext!) {
        UIGraphicsPushContext(ctx)
        let outterCircle = UIBezierPath(ovalInRect: CGRect(x: bWidth, y: bWidth, width: bounds.width - bWidth * 2, height: bounds.height - bWidth * 2))
        outterCircle.lineWidth = bWidth
        bColor.setStroke()
        (highlighted ? Constants.Design.Colors.Background : Constants.Design.Colors.DrumLetterBorder).setFill()
        outterCircle.stroke()
        outterCircle.fill()
        let innerCircle = UIBezierPath(ovalInRect: CGRect(x: bWidth + letterBorderWidth, y: bWidth + letterBorderWidth, width: bounds.width - bWidth * 2 - letterBorderWidth * 2, height: bounds.height - bWidth * 2 - letterBorderWidth * 2))
        (highlighted ? Constants.Design.Colors.DarkForeground : Constants.Design.Colors.Foreground).setFill()
        innerCircle.fill()
        let letterPoints = letterPositonRotationAryForRect(bounds, radius: bounds.height / 2 - bWidth - 2)
        let font = Constants.Design.BodyFont.fontWithSize(letterBorderWidth * 0.7)
        for (idx, (point, rotation)) in enumerate(letterPoints) {
            var index = idx - alphabet.count / 2 + 1 
            while index < 0 { index += alphabet.count }
            let context = UIGraphicsGetCurrentContext()
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, point.x, point.y);
            let textTransform = CGAffineTransformMakeRotation((rotation /  CGFloat(180 / M_PI)));
            CGContextConcatCTM(context, textTransform);
            CGContextTranslateCTM(context, -point.x, -point.y);
            Constants.Design.Colors.Text.set()
            (String(alphabet[index]) as NSString).drawAtPoint(point, withAttributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: Constants.Design.Colors.Text])
            CGContextRestoreGState(context);
            
        }
        UIGraphicsPopContext()
    }
    
    private func letterPositonRotationAryForRect(rect: CGRect, radius: CGFloat) -> [(CGPoint, CGFloat)] {
        let viewCenter = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let a = CGPoint(x: viewCenter.x, y: viewCenter.y - radius)
        let angle: CGFloat = 360 / CGFloat(alphabet.count)
        
        var ary = [(a, CGFloat(0))]
        
        for i in 1...alphabet.count/2 {
            let n = angle * CGFloat(i)
            if n >= 180 {
                ary.append((CGPoint(x: viewCenter.x, y: viewCenter.y + radius), CGFloat(180)))
            } else {
                let angleA = tanDeg(-90 + ((180 - n) / 2))
                let angleB = tanDeg(90 - n)
                let p = calcPoints(angleA, mB: angleB, a: a, b: viewCenter)
                ary.insert((p.0, 360 - n), atIndex: 0)
                ary.append((p.1, n))
                
            }
            
        }
        return ary
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


}
