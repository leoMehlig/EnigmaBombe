//
//  EnimgaPlugboardButton.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/19/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnimgaPlugboardButton: EnigmaButton {
    private struct Design {
       // static let BorderWidth: CGFloat = 6
        static let Margin: CGFloat = 3
        static let FontScale: CGFloat = 0.7
    }
    var letter: Character? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var waiting: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override var selected: Bool {
        didSet {
            self.setNeedsDisplay()
        }
    }
    override func drawRect(rect: CGRect) {
        if let char = letter {
            let circleRatio = bounds.width < 10 ? 10 : bounds.width
            
            let borderWidth = bounds.width / 5
            let circlePath = UIBezierPath(ovalInRect: CGRect(x: borderWidth/2, y: bounds.height - (circleRatio + borderWidth/2), width: circleRatio - borderWidth, height: circleRatio - borderWidth))
            circlePath.lineWidth = borderWidth
            if waiting || tapped {
                Constants.Design.Colors.Light.setStroke()
                UIColor.blackColor().setFill()
            } else if selected {
                Constants.Design.Colors.Text.setStroke()
                Constants.Design.Colors.Foreground.setFill()
            } else {
                UIColor.lightGrayColor().setStroke()
                UIColor.blackColor().setFill()
            }
            circlePath.stroke()
            circlePath.fill()
            let textRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - circleRatio )

            let font = Constants.Design.BodyFont.fontWithSize(textRect.height * Design.FontScale)
            let attributeCharacter = NSAttributedString(string: String(char), attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: Constants.Design.Colors.Text])
            let textSize = attributeCharacter.size()
            attributeCharacter.drawInRect(CGRect(x: (textRect.width - textSize.width) / 2, y: 0, width: textSize.width, height: textSize.height))
            
        }
    }
    
    
}
