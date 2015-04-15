//
//  EnigmaViewController.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnigmaViewController: UIViewController {
    var enigma = Enigma(
    @IBOutlet weak var keyboard: EnigmaKeywordView! {
        didSet {
            keyboard.keyTappedAction = { key in
                if key == Constants.Keyboard.backspaceCharacter {
                    self.deleteLastCharacter()
                } else {
                    self.appendCharacter(key)
                }
            }
        }
    }
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
