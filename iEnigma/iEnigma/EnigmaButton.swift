//
//  EnigmaButton.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/18/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnigmaButton: UIButton {
    internal var tapped = false {
        didSet {
            if tapped != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    private var addedActions = false
    override func didMoveToSuperview() {
        if !addedActions {
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
            addedActions = true
        }
    }
    
    func beginTouch() { tapped = true }
    
    func endTouch() { tapped = false }
}
