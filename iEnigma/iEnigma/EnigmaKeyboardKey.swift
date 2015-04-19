//
//  EnigmaKeyboardKey.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnigmaKeyboardKey: EnigmaButton {
    private struct Design {
        static let BorderWidth: CGFloat = 2
        static let FontScale: CGFloat = 0.6
        static let HorizontalSpace: CGFloat = 8
        static let VerticalSpace: CGFloat = 12
    }

    
    let key: Character
    
    init(key letter: Character) {
        key = letter
        super.init(frame: CGRectZero)
        
        self.contentMode = UIViewContentMode.Redraw
    }

    
    required init(coder aDecoder: NSCoder) {
        key = "-"
        super.init(coder: aDecoder)
    }
    
    private func CGRectFromSize(size: CGSize, centedInRect rect: CGRect) -> CGRect {
        if size.height >= rect.height && size.width >= rect.width { return rect }
        let y = (rect.height - size.height) / 2
        let x = (rect.width - size.width) / 2
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
    
    override func drawRect(rectToDraw: CGRect) {
        let rect = bounds
        let ratio = min(rect.height - (tapped ? 0 : Design.VerticalSpace), rect.width - (tapped ? 0 : Design.HorizontalSpace)) - Design.BorderWidth
        
        let circlePath = UIBezierPath(ovalInRect: CGRectFromSize(CGSize(width: ratio, height: ratio), centedInRect: rect))
        circlePath.lineWidth = Design.BorderWidth
        Constants.Design.Colors.Text.setStroke()
        (tapped ? Constants.Design.Colors.Foreground : Constants.Design.Colors.DarkForeground).setFill()
        circlePath.stroke()
        circlePath.fill()
        let font = Constants.Design.BodyFont.fontWithSize(ratio * Design.FontScale)
        let attributeCharacter = NSAttributedString(string: String(key), attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: tapped ? Constants.Design.Colors.DarkForeground : Constants.Design.Colors.Text])
        attributeCharacter.drawInRect(CGRectFromSize(attributeCharacter.size(), centedInRect: rect))
    }
  
    
}
