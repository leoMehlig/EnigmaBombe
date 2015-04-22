//
//  EnigmaRotorSettingView.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/21/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnigmaRotorSettingView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    private struct Design {
        static let Margin: CGFloat = 8
        static let NumberOfRotors: CGFloat = 3
    }
    
    var rotorObserver: NSObjectProtocol?
    var offsetObserver: NSObjectProtocol?
    
    var rotorOrderNumber: Int = 0 {
        didSet {
            if rotorObserver != nil { NSNotificationCenter.defaultCenter().removeObserver(rotorObserver!) }
            rotorObserver = NSNotificationCenter.defaultCenter().addObserverForName(EnigmaSettings.Notifications.Rotors, object: nil, queue: nil) { _ in
                self.updateRotorButtons()
            }
            if offsetObserver != nil { NSNotificationCenter.defaultCenter().removeObserver(offsetObserver!) }
            offsetObserver = NSNotificationCenter.defaultCenter().addObserverForName(EnigmaSettings.Notifications.Offset, object: nil, queue: nil) { _ in
                self.updatePickerView()
            }
            updatePickerView()
            updateRotorButtons()
            
        }
    }
    
    //MARK: - Buttons
    lazy var rotorButtons: [EnigmaRotorSettingButton] = {
        var buttons = [EnigmaRotorSettingButton]()
        for i in 0..<Int(Design.NumberOfRotors) {
            let b = EnigmaRotorSettingButton()
            b.rotorType = .StaticRotor(number: i)
            b.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
            buttons.append(b)
        }
        
        return buttons
    }()
    
    func updateRotorButtons() {
        let rotor = EnigmaSettings.rotors[rotorOrderNumber]
        for (idx, button) in enumerate(rotorButtons) {
            button.selected = rotor == idx
        }
    }
    
    func buttonTapped(sender: EnigmaRotorSettingButton) {
        let rotor: Int
        switch sender.rotorType! {
        case .StaticRotor(let num):
            rotor = num
        default: return
        }
        let oldRotor = EnigmaSettings.rotors[rotorOrderNumber]
        var rs = [Int]()
        for (idx, r) in enumerate(EnigmaSettings.rotors) {
            if idx == rotorOrderNumber {
                rs.append(rotor)
            } else {
                if rotor == r {
                rs.append(oldRotor)
                } else {
                    rs.append(r)
                }
            }
        }
        EnigmaSettings.rotors = rs
    }
    
    
    override func layoutSubviews() {
        var pickerWidth = bounds.width / Design.NumberOfRotors + 1
        if let w = self.pickerView(picker, attributedTitleForRow: 0, forComponent: 0)?.size().width {
            pickerWidth = min(max(pickerWidth, w), bounds.width / 3)
        }
        var rotorWidth = (bounds.width - pickerWidth - Design.Margin * Design.NumberOfRotors) / Design.NumberOfRotors
        let ratio = min(rotorWidth, bounds.height)
        for (idx, rotor) in enumerate(rotorButtons) {
            rotor.frame = CGRect(x: (bounds.width - pickerWidth) / Design.NumberOfRotors * CGFloat(idx), y: bounds.height / 2 - ratio / 2, width: ratio, height: ratio)
            addSubview(rotor)
        }
        offsetLabel.frame = CGRect(x: bounds.width - pickerWidth, y: 0, width: pickerWidth, height: 15)
        addSubview(offsetLabel)
        var pickerHeight = bounds.height - 15
        if pickerHeight <= 170 {
            pickerHeight = 162
        } else if pickerHeight <= 200 {
            pickerHeight = 180
        } else {
            pickerHeight = 216
        }
        picker.frame = CGRect(x: bounds.width - pickerWidth, y: (bounds.height - 15) / 2 - pickerHeight / 2, width: pickerWidth, height: pickerHeight)
        addSubview(picker)
    }
    
    
    //MARK: - PickerView
    lazy var offsetLabel: UILabel = {
        let l = UILabel()
        l.text = "Rotor Offset:"
        l.font = Constants.Design.BoldFont.fontWithSize(12)
        l.minimumScaleFactor = 0.5
        l.textColor = Constants.Design.Colors.Text
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
    lazy var picker: UIPickerView = {
        let p = UIPickerView()
        p.dataSource = self
        p.delegate = self
        return p
        }()
    
    func updatePickerView() {
        if picker.selectedRowInComponent(0) != offset {
            picker.selectRow(offset, inComponent: 0, animated: true)
        }
    }
    
    private var offset: Int {
        return EnigmaSettings.rotorOffset[rotorOrderNumber]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return alphabet.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let offsetNumStr = (row + 1 < 10 ? "0" : "") + "\(row + 1)"
        let offsetStr = offsetNumStr + "-" + String(alphabet[row])
        let font = Constants.Design.BodyFont
        return NSAttributedString(string: offsetStr, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: Constants.Design.Colors.Text])
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var offsets = [Int]()
        for (idx, n) in enumerate(EnigmaSettings.rotorOffset) {
            if idx == rotorOrderNumber {
                offsets.append(row)
            } else {
                offsets.append(n)
            }
        }
        EnigmaSettings.rotorOffset = offsets
    }
}
