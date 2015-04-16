//
//  EnigmaKeywordView.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnigmaKeywordView: UIView {
    
    var keyTappedAction: (Character -> Void)?
    private struct Design {
        static let HorizontalSpace: CGFloat = 8
        static let VerticalSpace: CGFloat = 12
    }
    private lazy var keys: [[UIButton]] = Constants.Keyboard.KeyMatrix.map { keyRow in
        return keyRow.map { key in
            var button = EnigmaKeyboardKey(key: key)
            button.addTarget(self, action: Selector("keyTapped:"), forControlEvents: UIControlEvents.TouchUpInside)
            return button
        }
    }
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.clearColor()
        
        if keys.first != nil && keys.first?.isEmpty == false {
            let width = (frame.width - Design.HorizontalSpace * CGFloat(keys.first!.count - 1)) / CGFloat(keys.first!.count)
            let height = (frame.height - Design.VerticalSpace * CGFloat(keys.count - 1)) / CGFloat(keys.count)
            let ratio = min(width, height)
            let size = CGSize(width: ratio, height: ratio)
            for (rowIdx, buttonRow) in enumerate(keys) {
                for (idx, button) in enumerate(buttonRow) {
                    let y = height * CGFloat(rowIdx) + Design.VerticalSpace * CGFloat(rowIdx)
                    let x = width * CGFloat(idx) + Design.HorizontalSpace * CGFloat(idx)
                    button.frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
                    if button.superview == nil {
                        self.addSubview(button)
                    }
                }
            }
        }
    }
    
    func keyTapped(sender: EnigmaKeyboardKey) { keyTappedAction?(sender.key) }
    
    
}
