//
//  EnigmaRotorPositionView.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/16/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit
import QuartzCore
class EnigmaRotorPositionView: EnigmaRotorView {
    
    
    
    lazy var upButton: EnigmaRotorPositionButton = {
        let b = EnigmaRotorPositionButton()
        b.up = true
        b.addTarget(self, action: "nextPositon", forControlEvents: .TouchUpInside)
        b.contentMode = .Redraw
        return b
        }()
    lazy var downButton: EnigmaRotorPositionButton = {
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
    lazy var letterLabel: UILabel = EnigmaRotorPositionView.createLabel()
    lazy var reuseLabel: UILabel = EnigmaRotorPositionView.createLabel()
    var observer: NSObjectProtocol?
    var currentPositon: Int = 0
    var rotorNumber: Int? {
        didSet {
            addPositionObserver()
        }
    }
    
    var rotorChanged: (EnigmaRotorPositionView -> Void)?
    
    
    private func addPositionObserver() {
        if observer != nil { NSNotificationCenter.defaultCenter().removeObserver(observer!) }
        if let number = rotorNumber {
            if EnigmaSettings.Notifications.rotorPositonChanged.count > rotorNumber {
                self.observer = NSNotificationCenter.defaultCenter().addObserverForName( EnigmaSettings.Notifications.rotorPositonChanged[number], object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self ] _ in
                    let newPosition = EnigmaSettings.rotorPositions[number]
                    if newPosition != self.currentPositon {
                        if self.currentPositon > newPosition && self.currentPositon < newPosition + 3 {
                            self.animateBackwards(newPosition: newPosition)
                        } else if newPosition >= alphabet.count - 2 && self.currentPositon < 2  {
                            self.animateBackwards(newPosition: newPosition)
                        } else  {
                            self.animateForward(newPosition: newPosition)
                        }
                    }
                }
            }
            currentPositon = EnigmaSettings.rotorPositions[number]
            self.letterLabel.attributedText = attributedStrFromString(String(alphabet[currentPositon]))
        }
    }
    var buttonSize: CGFloat = 0
    override func layoutSubviews() {
        let buttonRatio = max(22, bounds.height / 5)
        buttonSize = buttonRatio
        upButton.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 2)
        upButton.visbleRect = CGRect(x: bounds.midX - buttonRatio / 2, y: 0, width: buttonRatio, height: buttonRatio)
        downButton.frame = CGRect(x: 0, y: bounds.midY, width: bounds.width, height: bounds.height / 2)
        downButton.visbleRect = CGRect(x: bounds.midX - buttonRatio / 2, y: downButton.frame.height - buttonRatio, width: buttonRatio, height: buttonRatio)
        addSubview(upButton)
        addSubview(downButton)
        letterLabel.frame.size = letterLabel.intrinsicContentSize()

        letterLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        letterLabel.attributedText = attributedStrFromString(String(alphabet[currentPositon]))
        insertSubview(letterLabel, atIndex: 0)
    }
    
    func animateForward(#newPosition: Int) {
        currentPositon = newPosition
        let l = reuseLabel
        l.attributedText = attributedStrFromString(String(alphabet[currentPositon]))
        l.frame.size = l.intrinsicContentSize()
        l.frame.origin = CGPoint(x: bounds.midX - l.frame.width/2, y: bounds.height - buttonSize - l.frame.height / 2)
        l.alpha = 0.0
        
       insertSubview(l, atIndex: 0)
        UIView.animateWithDuration(0.3) {
            self.letterLabel.frame.origin = CGPoint(x: self.letterLabel.frame.origin.x, y: self.buttonSize - self.letterLabel.frame.height / 2)
            self.letterLabel.alpha = 0.0
            l.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            l.alpha = 1.0
            self.reuseLabel = self.letterLabel
            self.letterLabel = l
        }

    }
    func animateBackwards(#newPosition: Int) {
        currentPositon = newPosition
        let l = reuseLabel
        l.attributedText = attributedStrFromString(String(alphabet[currentPositon]))
        l.frame.size = l.intrinsicContentSize()
        l.frame.origin = CGPoint(x: bounds.midX - l.frame.width/2, y: buttonSize - l.frame.height / 2)
        l.alpha = 0.0
        insertSubview(l, atIndex: 0)
        UIView.animateWithDuration(0.3) {
            self.letterLabel.frame.origin = CGPoint(x: self.letterLabel.frame.origin.x, y: self.bounds.height - self.buttonSize - self.letterLabel.frame.height / 2)
            self.letterLabel.alpha = 0.0
            l.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            l.alpha = 1.0
            self.reuseLabel = self.letterLabel
            self.letterLabel = l
        }
    }
    func nextPositon() {
        var newPosition = currentPositon + 1
        if newPosition >= alphabet.count {
            newPosition = 0
        }
        animateForward(newPosition: newPosition)
        rotorChanged?(self)
    }
    
    func previousPositon() {
        var newPosition = currentPositon - 1
        if newPosition < 0 {
            newPosition = alphabet.count - 1
        }
        animateBackwards(newPosition: newPosition)
        rotorChanged?(self)
    }
    
    deinit {
        if observer != nil {
            NSNotificationCenter.defaultCenter().removeObserver(observer!)
        }
        println(self)
    }
}
