//
//  EnigmaRotorPositionButton.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/18/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnigmaRotorPositionButton: EnigmaButton {
    
    var up: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var visbleRect: CGRect = CGRectZero {
        didSet {
            self.setNeedsDisplay()
        }
    }
    private let marginSide: CGFloat = 5
    private let lineWidth: CGFloat = 2
    override func drawRect(rectToDraw: CGRect) {
        let circlePath = UIBezierPath(ovalInRect: CGRect(x: lineWidth + visbleRect.origin.x, y: lineWidth + visbleRect.origin.y, width: visbleRect.width - lineWidth * 2, height: visbleRect.height - lineWidth * 2))
        circlePath.lineWidth = lineWidth
        let arrovePath = UIBezierPath()
        arrovePath.moveToPoint(CGPoint(x: marginSide + visbleRect.origin.x, y: visbleRect.height / 2 + visbleRect.origin.y))
        arrovePath.addLineToPoint(CGPoint(x: visbleRect.width / 2 + visbleRect.origin.x, y: visbleRect.height / 6 * (up ? 2 : 4) + visbleRect.origin.y))
        arrovePath.addLineToPoint(CGPoint(x: visbleRect.width + visbleRect.origin.x - marginSide, y: visbleRect.height / 2 + visbleRect.origin.y))
        arrovePath.lineWidth = lineWidth
        arrovePath.lineCapStyle = kCGLineCapRound
        arrovePath.lineJoinStyle = kCGLineJoinRound
        if !tapped {
            Constants.Design.Colors.Text.setStroke()
            Constants.Design.Colors.Foreground.setFill()
        } else {
            Constants.Design.Colors.Foreground.setStroke()
            Constants.Design.Colors.DarkForeground.setFill()
        }
        circlePath.stroke()
        circlePath.fill()
        arrovePath.stroke()
    }
    
}
