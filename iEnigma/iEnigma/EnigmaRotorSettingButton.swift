//
//  EnigmaRotorSettingsView.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/21/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit
@IBDesignable
class EnigmaRotorSettingButton: EnigmaButton {
    enum RotorButtonType {
        case EnigmaRotor(orderNumber: Int)
        case StaticRotor(number: Int)
    }
    
    @IBInspectable var buttonText: String? {
        didSet {
            updateText()
        }
    }
    var rotorType: RotorButtonType? {
        didSet {
            updateText()
        }
    }
    
    let rotorLayer: EnigmaRotorLayer = {
        let l = EnigmaRotorLayer()
        return l
        }()
    
    private func numberToRoman(n: Int) -> String {
        switch n {
        case 1: return "I"
        case 2: return "II"
        case 3: return "III"
        case 4: return "IV"
        case 5: return "V"
        default: break
        }
        return ""
    }
    
    override var tapped: Bool {
        didSet {
            updateColor()
        }
    }
    
    override var selected: Bool {
        didSet {
            updateColor()
        }
    }
    
    private func updateColor() {
        if tapped || selected {
            rotorLayer.strokeColor = Constants.Design.Colors.Foreground
            rotorLayer.fillColor = Constants.Design.Colors.DarkForeground
        } else {
            rotorLayer.strokeColor = Constants.Design.Colors.Text
            rotorLayer.fillColor = Constants.Design.Colors.Foreground
        }
    }
    private var rotorString: String? {
        if let type = rotorType {
            switch type {
            case .EnigmaRotor(let orderNumber):
                if EnigmaSettings.rotors.count > orderNumber {
                    return numberToRoman(EnigmaSettings.rotors[orderNumber] + 1)
                }
            case .StaticRotor(let num):
                return numberToRoman(num + 1)
            }
        } else if let str = buttonText {
            return str
        }
        
        return nil
    }
    
    func updateText() {
        textLabel.text = rotorString
        textLabel.hidden = textLabel.text == nil
        let textLength = count(textLabel.text  ?? "")
        let fontScale = textLength <= 3  ? 0.6 : 0.9 / CGFloat(textLength)
        textLabel.font = Constants.Design.BodyFont.fontWithSize(textLabel.bounds.height * fontScale)
    }

//    override func drawRect(rect: CGRect) {
//        
//        rotorLayer.frame = bounds
//        rotorLayer.drawInContext(UIGraphicsGetCurrentContext())
//        let font = Constants.Design.BodyFont.fontWithSize(bounds.height * 0.6)
//        let numberAttrStr = NSAttributedString(string: rotorString, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: Constants.Design.Colors.Text])
//        let numberSize = numberAttrStr.size()
//        numberAttrStr.drawInRect(CGRectFromSize(numberSize, centedInRect: bounds))
//    }
    
    private lazy var textLabel: UILabel = {
        let l = UILabel()
        l.font = Constants.Design.BodyFont
        l.textColor = Constants.Design.Colors.Text
        l.minimumScaleFactor = 0.7
        
        l.adjustsFontSizeToFitWidth = true
        l.textAlignment = .Center
        return l
        }()
    
    override func layoutSubviews() {
        
        rotorLayer.frame = bounds
        layer.addSublayer(rotorLayer)
        rotorLayer.setNeedsDisplay()
        let (radius, _) = rotorLayer.radius

        var rect = CGRect(x: bounds.width / 2 - radius, y: bounds.height / 2 - radius, width: radius * 2, height: radius * 2)
        let r = min(rect.height, rect.width)
        let cap = sqrt(pow((sqrt(r * r * 2) - r) / 2, 2) / 2)
        textLabel.frame.size = CGSize(width: (rect.width - 2 * cap) * textLabel.transform.a, height: (rect.height - 2 * cap) * textLabel.transform.d)
        textLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        updateText()
        
        self.addSubview(textLabel)

    }
    
    
}
