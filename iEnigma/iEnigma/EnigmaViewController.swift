//
//  EnigmaViewController.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnigmaViewController: UIViewController {
    var enigma = EnigmaSettings.enigmaFromSettings
    
    //MARK: - TextView
    var inputText = "" {
        didSet {
            if inputText == oldValue { return }
            inputTextView.attributedText = attributedStrFromString(inputText)
            if count(inputText) == count(oldValue) {
                if inputText != oldValue {
                    enigma.resetRotors()
                    encodedText = enigma.encodeText(inputText)
                }
            } else if count(inputText) > count(oldValue) {
                encodedText += enigma.encodeText(inputText[oldValue.endIndex..<inputText.endIndex])
            } else if count(inputText) < count(oldValue) {
                let remainingString = oldValue[oldValue.startIndex..<inputText.endIndex]
                if remainingString == inputText {
                    let deleted = count(oldValue) - count(inputText)
                    for _ in 0..<deleted {
                        enigma.rotor(0)?.stepBack()
                        enigma.rotor(0)?.stepBackSecondRotorIfNeeded()
                    }
                    encodedText = encodedText[encodedText.startIndex..<inputText.endIndex]
                } else {
                    enigma.resetRotors()
                    encodedText = enigma.encodeText(inputText)
                }
            }
        }
    }
    var encodedText = "" {
        didSet {
            if encodedText != oldValue {
                encodeTextView.attributedText = attributedStrFromString(encodedText)
                EnigmaSettings.rotorPositions = self.enigma.rotors.map { $0.rotorPosition }
                
            }
        }
    }
    
    @IBOutlet weak var inputTextView: UITextView! {
        didSet {
            inputTextView?.font = Constants.Design.BodyFont
            inputTextView?.backgroundColor = UIColor(patternImage: UIImage(named: "clean_paper_background.png")!)
            inputTextView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        }
    }
    @IBOutlet weak var encodeTextView: UITextView! {
        didSet {
            encodeTextView?.font = Constants.Design.BodyFont
            encodeTextView?.backgroundColor = UIColor(patternImage: UIImage(named: "clean_paper_background.png")!)
            encodeTextView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if let textView = object as? UITextView where keyPath == "contentSize" {
            let topCorrect = textView.bounds.size.height - textView.contentSize.height
            textView.setContentOffset(CGPoint(x: 0, y: -topCorrect), animated: false)
        }
    }
    private func attributedStrFromString(string: String) -> NSAttributedString {
        let font = Constants.Design.BodyFont
        return NSAttributedString(string: string, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: Constants.Design.Colors.DarkForeground, NSKernAttributeName: 2.0])
    }
    
    
    //MARK: - Keyboard
    @IBOutlet weak var keyboard: EnigmaKeyboardView! {
        didSet {
            keyboard.keyTappedAction = { key in
                if key == Constants.Keyboard.backspaceCharacter {
                    if count(self.inputText) > 0 {
                        self.inputText = self.inputText[self.inputText.startIndex..<advance(self.inputText.endIndex, -1)]
                    }
                } else {
                    self.inputText += String(key)
                }
            }
        }
    }
    
    //MARK: - Rotor Position
    
    @IBOutlet weak var rotorPositonViewI: EnigmaRotorPositionView! {
        didSet {
            rotorPositonViewI.rotorNumber = 0
            rotorPositonViewI.rotorChanged = self.rotorPositionChanged
        }
    }
    @IBOutlet weak var rotorPositonViewII: EnigmaRotorPositionView! {
        didSet {
            rotorPositonViewII.rotorNumber = 1
            rotorPositonViewII.rotorChanged = self.rotorPositionChanged
        }
    }
    @IBOutlet weak var rotorPositonViewIII: EnigmaRotorPositionView! {
        didSet {
            rotorPositonViewIII.rotorNumber = 2
            rotorPositonViewIII.rotorChanged = self.rotorPositionChanged
        }
    }
    
    func rotorPositionChanged(rotorView: EnigmaRotorPositionView) {
        let text = inputText
        if let number = rotorView.rotorNumber {
            enigma.rotor(number)?.rotorPosition = rotorView.currentPositon
            enigma.rotor(number)?.startRotorPosition = rotorView.currentPositon
            println(rotorView.currentPositon)
            EnigmaSettings.rotorPositions = self.enigma.rotors.map { $0.rotorPosition }
            
        }
    }
    
    //MARK: - Settings
    
    @IBOutlet weak var plugboardLabel: UILabel!
    @IBOutlet weak var plugboardView: EnimgaPlugboardSettingsView!
    private var plugboardExpanded: Bool = false
    
    @IBOutlet weak var plugboardHeightConstraint: NSLayoutConstraint!
    @IBAction func plugboardTapped(sender: UITapGestureRecognizer) {
        var height = self.plugboardView.bounds.width * (2.5/13)
        self.plugboardExpanded = !self.plugboardExpanded
        if self.plugboardExpanded {
            self.plugboardView.hidden = false
            self.plugboardLeading.constant = -self.view.bounds.width
            self.plugboardTrailing.constant = -self.view.bounds.width
            self.view.layoutIfNeeded()
            self.plugboardHeightConstraint.constant = height
            self.bottomConstaint.constant = -height
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }) { fi in
                    if fi {
                        self.plugboardTrailing.constant = 0
                        self.plugboardLeading.constant = 0

                        self.plugboardView.hidden = false
                        UIView.animateWithDuration(0.3) {
                            self.view.layoutIfNeeded()
                        }
                    }
                    
            }
            
            
        } else {
            self.plugboardLeading.constant = -self.view.bounds.width
            self.plugboardTrailing.constant = -self.view.bounds.width

            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }) { fi in
                    if fi {
                        self.plugboardHeightConstraint.constant = 0
                        self.bottomConstaint.constant = 0
                        self.plugboardView.hidden = true
                        self.plugboardTrailing.constant = 0
                        self.plugboardLeading.constant = 0

                        UIView.animateWithDuration(0.3) {
                            self.view.layoutIfNeeded()
                        }
                    }
                    
            }
        }

       
        
    }
    
    
    @IBOutlet weak var plugboardLeading: NSLayoutConstraint!
    @IBOutlet weak var plugboardTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstaint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}
