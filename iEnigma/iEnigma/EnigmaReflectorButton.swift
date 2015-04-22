//
//  EnigmaReflectorView.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/20/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit
@IBDesignable
class EnigmaReflectorButton: EnigmaButton {
    
    @IBInspectable var borderWidth: CGFloat = 3
    var letter: Character = "A" {
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
        let path = UIBezierPath(ovalInRect: CGRect(x: borderWidth, y: borderWidth, width: bounds.width - borderWidth * 2, height: bounds.height - borderWidth * 2))
        path.lineWidth = borderWidth
        if tapped || selected {
            Constants.Design.Colors.Foreground.setStroke()
            Constants.Design.Colors.DarkForeground.setFill()
        } else {
            Constants.Design.Colors.Text.setStroke()
            Constants.Design.Colors.Foreground.setFill()
        }
        path.stroke()
        path.fill()
        let font = Constants.Design.BodyFont.fontWithSize(bounds.height * 0.5)
        let attributeCharacter = NSAttributedString(string: String(letter), attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: Constants.Design.Colors.Text])
        attributeCharacter.drawInRect(CGRectFromSize(attributeCharacter.size(), centedInRect: rect))
    }
    
    
}
