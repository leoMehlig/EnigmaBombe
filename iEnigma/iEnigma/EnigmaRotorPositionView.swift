//
//  EnigmaRotorPositionView.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/16/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

@IBDesignable
class EnigmaRotorPositionView: UIView {
    //MARK: - Public
    typealias RotorPositionCallBack = (EnigmaRotorPositionView, Int) -> Void
    var rotorChanged: RotorPositionCallBack?
    
    var rotorPosition: Int = 0 {
        didSet {
            while rotorPosition >= alphabet.count { rotorPosition -= alphabet.count }
            while rotorPosition < 0  { rotorPosition += alphabet.count }
            if rotorPosition != oldValue {
                if oldValue > rotorPosition && oldValue < rotorPosition + 3 {
                    self.animateBackwards()
                } else if rotorPosition >= alphabet.count - 2 && oldValue < 2  {
                    self.animateBackwards()
                } else  {
                    self.animateForward()
                }
            }
        }
    }
    
    
    private lazy var upButton: EnigmaRotorPositionButton = {
        let b = EnigmaRotorPositionButton()
        b.up = true
        b.addTarget(self, action: "nextPositon", forControlEvents: .TouchUpInside)
        b.contentMode = .Redraw
        return b
        }()
    
    private lazy var downButton: EnigmaRotorPositionButton = {
        let b = EnigmaRotorPositionButton()
        b.up = false
        b.addTarget(self, action: "previousPositon", forControlEvents: .TouchUpInside)
        return b
        }()
    
    private class func createLabel() -> UILabel {
        let l = UILabel()
        return l
    }
    
    private func attributedStrFromString(string: String) -> NSAttributedString {
        let font = Constants.Design.BodyFont.fontWithSize(bounds.height * 0.4)
        return NSAttributedString(string: string, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: Constants.Design.Colors.Text])
    }
    
    private lazy var letterLabel: UILabel = EnigmaRotorPositionView.createLabel()
    private lazy var reuseLabel: UILabel = EnigmaRotorPositionView.createLabel()
    
    private var rotorLayer: EnigmaRotorLayer = {
        let l = EnigmaRotorLayer()
        return l
        }()
    
    
    
    var buttonSize: CGFloat = 0
    override func layoutSubviews() {
        if !animating {
            rotorLayer.frame = bounds
            layer.addSublayer(rotorLayer)
            let buttonRatio = bounds.height / 4
            rotorLayer.margin = buttonRatio/2
            buttonSize = buttonRatio
            upButton.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 2)
            upButton.visbleRect = CGRect(x: bounds.midX - buttonRatio / 2, y: 0, width: buttonRatio, height: buttonRatio)
            downButton.frame = CGRect(x: 0, y: bounds.midY, width: bounds.width, height: bounds.height / 2)
            downButton.visbleRect = CGRect(x: bounds.midX - buttonRatio / 2, y: downButton.frame.height - buttonRatio, width: buttonRatio, height: buttonRatio)
            addSubview(upButton)
            addSubview(downButton)
            letterLabel.frame.size = letterLabel.intrinsicContentSize()
            
            letterLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
            if letterLabel.attributedText == nil || letterLabel.attributedText?.string == nil {
                letterLabel.attributedText = attributedStrFromString(String(alphabet[rotorPosition]))
            } else {
                letterLabel.attributedText = attributedStrFromString(letterLabel.text!)
            }
            insertSubview(letterLabel, belowSubview: upButton)
        }
    }
    var animating = false
    private func animateForward() {
        let l = reuseLabel
        l.attributedText = attributedStrFromString(String(alphabet[rotorPosition]))
        l.frame.size = l.intrinsicContentSize()
        l.frame.origin = CGPoint(x: bounds.midX - l.frame.width/2, y: bounds.height - buttonSize - l.frame.height / 2)
        l.alpha = 0.0
        
        insertSubview(l, belowSubview: downButton)
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: nil, animations: { () -> Void in
            self.animating = true
            self.letterLabel.frame.origin = CGPoint(x: self.letterLabel.frame.origin.x, y: self.buttonSize - self.letterLabel.frame.height / 2)
            self.letterLabel.alpha = 0.0
            l.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            l.alpha = 1.0
            self.reuseLabel = self.letterLabel
            self.letterLabel = l
            }) { fi in
                if fi {
                    self.animating = false
                }
        }
    }
    private func animateBackwards() {
        let l = reuseLabel
        l.attributedText = attributedStrFromString(String(alphabet[rotorPosition]))
        l.frame.size = l.intrinsicContentSize()
        l.frame.origin = CGPoint(x: bounds.midX - l.frame.width/2, y: buttonSize - l.frame.height / 2)
        l.alpha = 0.0
        insertSubview(l, belowSubview: upButton)
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: nil, animations: { () -> Void in
            self.animating = true
            self.letterLabel.frame.origin = CGPoint(x: self.letterLabel.frame.origin.x, y: self.bounds.height - self.buttonSize - self.letterLabel.frame.height / 2)
            self.letterLabel.alpha = 0.0
            l.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            l.alpha = 1.0
            self.reuseLabel = self.letterLabel
            self.letterLabel = l
            }) { fi in
                if fi {
                    self.animating = false
                }
        }
       
    }
    
    func nextPositon() {
        rotorPosition++
        rotorChanged?(self, 1)
    }
    
    func previousPositon() {
        rotorPosition--
        rotorChanged?(self, -1)
    }
    
    
}
