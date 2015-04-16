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
    var inputText = "" {
        didSet {
            if inputText == oldValue { return }
            inputTextView.text = inputText
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
                encodeTextView.text = encodedText
            }
        }
    }
    @IBOutlet weak var keyboard: EnigmaKeywordView! {
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
    
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var encodeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func appendCharacter(char: Character) {
        
    }
    
    func deleteLastCharacter() {
        
    }
    
    func resetAll() {
        
    }
    
}
