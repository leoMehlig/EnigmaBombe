//
//  BombeDrumButton.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/23/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit
@IBDesignable
class BombeDrumButton: EnigmaButton {
    
    @IBInspectable var borderColor: UIColor = UIColor.whiteColor() {
        didSet {
            drumLayer.bColor = borderColor
        }
    }
    
    @IBInspectable var letterBorderWidth: CGFloat = 10 {
        didSet {
            drumLayer.letterBorderWidth = letterBorderWidth
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 3 {
        didSet {
            drumLayer.bWidth = borderWidth
        }
    }
    
    @IBInspectable var contentText: String? {
        didSet {
            textLabel.text = contentText
            textLabel.hidden = contentText == nil
        }
    }
    
    override var tapped: Bool {
        didSet {
            drumLayer.highlighted = tapped
        }
    }
    
    let drumLayer = BombeDrumLayer()
    private var upIdx = 0
    func rotateOneLetter() {

        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.duration = 0.3
        let rotation = CGFloat(M_PI * 2) / CGFloat(alphabet.count)
        animation.fromValue = rotation * CGFloat(upIdx)
        upIdx++
        animation.toValue = rotation * CGFloat(upIdx)
        if upIdx >= alphabet.count {
            upIdx = 0
        }
        drumLayer.addAnimation(animation, forKey: "transform.rotation")
    }
    
    
    
    private lazy var textLabel: UILabel = {
        let l = UILabel()
        l.font = Constants.Design.BoldFont.fontWithSize(32)
        l.textColor = Constants.Design.Colors.DarkForeground
        l.minimumScaleFactor = 0.9
        l.adjustsFontSizeToFitWidth = true
        l.textAlignment = .Center
        return l
        }()
    
    override func layoutSubviews() {
        drumLayer.frame = bounds
        layer.addSublayer(drumLayer)
        var rect = CGRect(x: borderWidth + letterBorderWidth, y: borderWidth + letterBorderWidth, width: frame.width - borderWidth * 2 - letterBorderWidth * 2, height: frame.height - borderWidth * 2 - letterBorderWidth * 2)
        rect = frame
        let r = min(rect.height, rect.width)
        let cap = sqrt(pow((sqrt(r * r * 2) - r) / 2, 2) / 2)
        textLabel.frame.size = CGSize(width: (rect.width - 2 * cap) * textLabel.transform.a, height: (rect.height - 2 * cap) * textLabel.transform.d)
        textLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        self.addSubview(textLabel)
        
        
        
        
    }
}
