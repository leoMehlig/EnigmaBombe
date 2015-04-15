//
//  EnigmaKeyboardKey.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnigmaKeyboardKey: UIButton {
    private struct Design {
        static let borderWidth: CGFloat = 2
        static let fontScale: CGFloat = 0.6
    }
    let key: Character
    private var tapped = false {
        didSet {
            if tapped != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    init(key letter: Character) {
        key = letter
        super.init(frame: CGRectZero)
        self.contentMode = UIViewContentMode.Redraw
        //Tap
        self.addTarget(self, action: "beginTouch", forControlEvents: .TouchDown)
        self.addTarget(self, action: "beginTouch", forControlEvents: .TouchDragEnter)
        self.addTarget(self, action: "beginTouch", forControlEvents: .TouchDragInside)

        //End
        self.addTarget(self, action: "endTouch", forControlEvents: .TouchDragOutside)
        self.addTarget(self, action: "endTouch", forControlEvents: .TouchDragExit)
        self.addTarget(self, action: "endTouch", forControlEvents: .TouchUpInside)
        self.addTarget(self, action: "endTouch", forControlEvents: .TouchUpOutside)
        self.addTarget(self, action: "endTouch", forControlEvents: .TouchCancel)
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
        let circlePath = UIBezierPath(ovalInRect: CGRect(x: Design.borderWidth, y: Design.borderWidth, width: rect.width - Design.borderWidth*2, height: rect.width - Design.borderWidth*2))
        circlePath.lineWidth = Design.borderWidth
        Constants.Design.Colors.Text.setStroke()
        (tapped ? Constants.Design.Colors.Foreground : Constants.Design.Colors.DarkForeground).setFill()
        circlePath.stroke()
        circlePath.fill()
        let font = Constants.Design.BodyFont.fontWithSize(rect.height * Design.fontScale)
        let attributeCharacter = NSAttributedString(string: String(key), attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: tapped ? Constants.Design.Colors.DarkForeground : Constants.Design.Colors.Text])
        attributeCharacter.drawInRect(CGRectFromSize(attributeCharacter.size(), centedInRect: rect))
    }
    
    func beginTouch() { tapped = true }
    
    func endTouch() { tapped = false }
    
}
