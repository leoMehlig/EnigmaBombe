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
    
    var rotorType: RotorButtonType? {
        didSet {
            self.setNeedsDisplay()
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
        return "-"
    }
    
    private var rotorString: String {
        if let type = rotorType {
            switch type {
            case .EnigmaRotor(let orderNumber):
                if EnigmaSettings.rotors.count > orderNumber {
                    return numberToRoman(EnigmaSettings.rotors[orderNumber] + 1)
                }
            case .StaticRotor(let num):
                return numberToRoman(num + 1)
            }
        }
        
        return "-"
    }

    override func drawRect(rect: CGRect) {
        if tapped || selected {
            rotorLayer.strokeColor = Constants.Design.Colors.Foreground
            rotorLayer.fillColor = Constants.Design.Colors.DarkForeground
        } else {
            rotorLayer.strokeColor = Constants.Design.Colors.Text
            rotorLayer.fillColor = Constants.Design.Colors.Foreground
        }
        rotorLayer.frame = bounds
        rotorLayer.drawInContext(UIGraphicsGetCurrentContext())
        let font = Constants.Design.BodyFont.fontWithSize(bounds.height * 0.6)
        let numberAttrStr = NSAttributedString(string: rotorString, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: Constants.Design.Colors.Text])
        let numberSize = numberAttrStr.size()
        numberAttrStr.drawInRect(CGRectFromSize(numberSize, centedInRect: bounds))
    }
    
    
}
