//
//  EnimgaPlugboardSettingsView.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/19/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnimgaPlugboardSettingsView: UIView {
    
    private struct Design {
        static let Margin: CGFloat = 4
    }
    var selectedButton: EnimgaPlugboardButton?
    lazy var plugboardButtons: [EnimgaPlugboardButton] = {
        return alphabet.map {
            let button = EnimgaPlugboardButton()
            button.letter = $0
            button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
            button.contentMode = .Redraw
            return button
        }
        }()
    override func layoutSubviews() {
        
        //let rect = bounds.height == 0 ? CGRect(x: 0, y: 0, width: bounds.width, height: 20) : bounds
        var rect = bounds
        let buttonsPerRow = CGFloat(plugboardButtons.count / 2)
        let lineHeight = min((rect.height - Design.Margin) / 2, (rect.width - Design.Margin * (buttonsPerRow - 1)) / buttonsPerRow * 2)
        let horizontalMargin = (rect.width - lineHeight / 2 * buttonsPerRow) / (buttonsPerRow - 1)
        for (idx, button) in enumerate(plugboardButtons) {
            let y: CGFloat
            var i: CGFloat
            if CGFloat(idx) < buttonsPerRow {
                y = 0
                i = CGFloat(idx)
            } else {
                y = rect.height - lineHeight
                i = CGFloat(idx - alphabet.count / 2)
            }
            let x = lineHeight / 2 * i + horizontalMargin * i
            UIView.animateWithDuration(0.3) {

            button.frame = CGRect(x: x, y: y, width: lineHeight / 2, height: lineHeight)
            }
            addSubview(button)
        }
        addPlugboardObserver()
        drawPlugboard()
    }
    var observer: NSObjectProtocol?
    func addPlugboardObserver() {
        if observer == nil {
            observer = NSNotificationCenter.defaultCenter().addObserverForName(EnigmaSettings.Notifications.Plugboard, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
                self.drawPlugboard()
            }
        }
    }
    
    let shapeLayer = CAShapeLayer()
    func drawPlugboard() {
        let plugboard = EnigmaSettings.plugboard
        let path = UIBezierPath()
        for pair in plugboard {
            let button1 = plugboardButtons[idxAlphabet[pair.letter1]!]
            let button2 = plugboardButtons[idxAlphabet[pair.letter2]!]
            button1.selected = true
            button2.selected = true
            path.moveToPoint(button1.center)
            if button1.center.y == button2.center.y {
                var distance = button1.center.x - button2.center.x
                path.addQuadCurveToPoint(button2.center, controlPoint: CGPoint(x: button2.center.x + distance / 2, y: (button2.center.y < bounds.midY ? bounds.maxY : bounds.minY)))
            } else {
                path.addLineToPoint(button2.center)
            }
            
        }
        shapeLayer.frame = bounds
        shapeLayer.strokeColor = Constants.Design.Colors.Foreground.CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.lineWidth = bounds.height / 50
        layer.addSublayer(shapeLayer)
        shapeLayer.zPosition = 100
        shapeLayer.path = path.CGPath
    }
  
    func buttonTapped(button: EnimgaPlugboardButton) {
        if let char = button.letter {
            if selectedButton == button {
                button.waiting = false
                selectedButton = nil
            } else if let lastButton = selectedButton where !button.selected {
                button.selected = true
                lastButton.selected = true
                lastButton.waiting = false
                selectedButton = nil
                EnigmaSettings.plugboard = EnigmaSettings.plugboard + [PlugboardPair(char, lastButton.letter!)]
            } else if !button.selected {
                button.waiting = true
                selectedButton = button
            } else {
                var newPairs = [PlugboardPair]()
                for pair in EnigmaSettings.plugboard {
                    if let c = pair.containsLetter(char){
                         plugboardButtons[idxAlphabet[c]!].selected = false
                    } else {
                        newPairs.append(pair)
                    }
                }
                if let lastButton = selectedButton {
                    button.selected = true
                    lastButton.selected = true
                    lastButton.waiting = false
                    newPairs.append(PlugboardPair(char, lastButton.letter!))
                    selectedButton = nil
                } else {
                    button.waiting = false
                    button.selected = false
                }
                EnigmaSettings.plugboard = newPairs
                
            }
        }
    }
}
