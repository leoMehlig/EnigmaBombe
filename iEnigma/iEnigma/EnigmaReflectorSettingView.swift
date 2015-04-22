//
//  EnigmaReflectorSettingView.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/20/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnigmaReflectorSettingView: UIView {
    
    private struct Design {
        static let Margin: CGFloat = 8
    }
    var observer: NSObjectProtocol?
    lazy var reflectorButtons: [EnigmaReflectorButton] = {
        let letters: [Character] = ["A", "B", "C"]
        var buttons = [EnigmaReflectorButton]()
        for char in letters {
            let b = EnigmaReflectorButton()
            b.letter = char
            b.addTarget(self, action: "reflectorButtonTapped:", forControlEvents: .TouchUpInside)
            buttons.append(b)
        }
        self.observer = NSNotificationCenter.defaultCenter().addObserverForName(EnigmaSettings.Notifications.Reflector, object: nil, queue: nil) { _ in
            self.updateReflector()
        }
        return buttons
    }()
    
    func updateReflector() {
        let currentReflector = EnigmaSettings.reflector
        for (idx, button) in enumerate(reflectorButtons) {
            if idx == currentReflector {
                button.selected = true
            } else {
                button.selected = false
            }
        }
    }
    
    override func layoutSubviews() {
        self.updateReflector()
        let ratio: CGFloat = min(bounds.height, (bounds.width - Design.Margin *  2) / 3)
        let y = bounds.height / 2 - ratio / 2
        if reflectorButtons.count > 0 {
            let b = reflectorButtons[0]
            b.frame = CGRect(x: 0, y: y, width: ratio, height: ratio)
            addSubview(b)
        }
        if reflectorButtons.count > 1 {
            let b = reflectorButtons[1]
            b.frame = CGRect(x: bounds.width / 2 - ratio / 2, y: y, width: ratio, height: ratio)
            addSubview(b)
        }
        if reflectorButtons.count > 2 {
            let b = reflectorButtons[2]
            b.frame = CGRect(x: bounds.width - ratio, y: y, width: ratio, height: ratio)
            addSubview(b)
        }
    }
    
    func reflectorButtonTapped(sender: EnigmaReflectorButton) {
        EnigmaSettings.reflector = sender.letter == "A" ? 0 : sender.letter == "B" ? 1 : 2
    }

}
