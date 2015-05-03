//
//  BombeSettingViewController.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/23/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class BombeSettingViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, ZoombleViewRect {
    
    //MARK: - Ciphertext
    var unmatchingParts: [Bombe.StringWithLocation]? {
        didSet {
            matchesLabel.text = "\(unmatchingParts?.count ?? 0) matches"
            updateTimeNeeded()

        }
    }
    
    @IBOutlet weak var guessedWordTextField: UITextField!
    @IBOutlet weak var encodedTextView: UITextView!
    @IBAction func pasteEncodedText(sender: UIButton) {
        if let text = UIPasteboard.generalPasteboard().string {
            self.encodedTextView.text = checkTextAndRemoveInvalideCharacters(text, totalString: "", range: NSMakeRange(0, count(text)))
            updateUnmatchingParts()
        }
        
    }
    
    @IBOutlet weak var matchesLabel: UILabel!
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if let newText = checkTextAndRemoveInvalideCharacters(string, totalString: textField.text, range: range) {
            textField.text = newText
            updateUnmatchingParts()
            return false
        }
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        if let newText = checkTextAndRemoveInvalideCharacters(text, totalString: textView.text, range: range) {
            textView.text = newText
            updateUnmatchingParts()
            return false
        }
        return true
    }
    private func checkTextAndRemoveInvalideCharacters(string: String, var totalString: String, range: NSRange) -> String? {
        if string.isEmpty { return nil }
        var currentIdx = range.location
        for c in string.uppercaseString {
            if idxAlphabet[c] != nil {
                totalString.insert(c, atIndex: advance(totalString.startIndex, currentIdx))
                currentIdx++
            }
        }
        return totalString
    }
    
    func textViewDidChange(textView: UITextView) {
        updateUnmatchingParts()
    }
    @IBAction func textFieldChanged(sender: UITextField) {
        updateUnmatchingParts()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func updateUnmatchingParts() {
        NSOperationQueue().addOperationWithBlock {
            if let text = self.encodedTextView.text {
                if let word = self.guessedWordTextField.text {
                    if count(text) >= count(word) {
                        let unmatching = Bombe.completUnmatchingPartsOfText(text, toWord: word)
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.unmatchingParts = unmatching
                        }
                        return
                    }
                    
                }
            }
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.unmatchingParts = nil
            }
        }
    }
    
    
    //MARK: - Settings
    private var rotorObserver: NSObjectProtocol?
    private var rotorPositionObserver: NSObjectProtocol?
    private var reflectorObserver: NSObjectProtocol?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        rotorObserver = NSNotificationCenter.defaultCenter().addObserverForName(EnigmaSettings.Notifications.Rotors, object: nil, queue: nil) { _ in
            self.updateRotors()
        }
        updateRotors()
        
        rotorPositionObserver = NSNotificationCenter.defaultCenter().addObserverForName(EnigmaSettings.Notifications.Positon, object: nil, queue: nil) { _ in
            self.updateRotorPositons()
        }
        updateRotorPositons()
        

        
        reflectorObserver = NSNotificationCenter.defaultCenter().addObserverForName(EnigmaSettings.Notifications.Reflector, object: nil, queue: nil) { _ in
            self.updateReflector()
        }
        updateReflector()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if rotorObserver != nil { NSNotificationCenter.defaultCenter().removeObserver(rotorObserver!) }
        if rotorPositionObserver != nil { NSNotificationCenter.defaultCenter().removeObserver(rotorPositionObserver!) }
        if reflectorObserver != nil { NSNotificationCenter.defaultCenter().removeObserver(reflectorObserver!) }
        
    }
    @IBOutlet weak var rotorLabel: UILabel!
    private func updateRotors() {
        rotorLabel?.text = EnigmaDisplayer.Rotors(EnigmaSettings.rotors)
    }
    @IBOutlet weak var rotorPositionLabel: UILabel!
    private func updateRotorPositons() {
        rotorPositionLabel?.text = EnigmaDisplayer.RotorPositions(EnigmaSettings.rotorPositions)
    }
 
    @IBOutlet weak var reflectorLabel: UILabel!
    private func updateReflector() {
        reflectorLabel.text = String(EnigmaDisplayer.Reflector(EnigmaSettings.reflector))
    }
    
    @IBOutlet weak var rotorSwitch: UISwitch!
    @IBOutlet weak var rotorPositionSwitch: UISwitch!
    @IBOutlet weak var reflectorSwitch: UISwitch!
    
    @IBAction func settingsSwitchChanged(sender: UISwitch) {
        updateTimeNeeded()
    }
    
    @IBOutlet weak var timeNeededLabel: UILabel!
    private func updateTimeNeeded() {
        timeNeededLabel.text = Bombe.timeNeededStringForWords(self.unmatchingParts?.count ?? 0, rotor: rotorSwitch?.on ?? true, ref: reflectorSwitch?.on ?? true, pos: rotorPositionSwitch?.on ?? false)
        
    }
    //MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "drumSegue" {
            if unmatchingParts?.count > 0 {
                return true
            } else {
                let title: String
                let message: String
                if guessedWordTextField.text.isEmpty && encodedTextView.text.isEmpty {
                    title = "No guessed word and no text to decrypt"
                    message = "Enter a encrypted text and a word that could be in that text"
                } else if guessedWordTextField.text.isEmpty {
                    title = "No guessed word"
                    message = "The Bombe needs a word that could be the encrypted text"
                } else if encodedTextView.text.isEmpty {
                    title = "No ciphertext text"
                    message = "The Bombe can't guess the text you want to decrypt"
                } else {
                    title = "No possible matches"
                    message = "Seems the ciphertext doesn't contain the word you guessed. Please guess another one"
                }
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel) { _ in })
                presentViewController(alert, animated: true, completion: nil)
                return false
            }
        }
       return super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "drumSegue" {
            if let v = sender as? UIView {
                zoomRect = v.convertRect(v.bounds, toView: view)
            }
            if let loadingVC = segue.destinationViewController as? BombeLoadingViewController {
                loadingVC.bombe = Bombe(rotor: rotorSwitch.on, reflector: reflectorSwitch.on, position: rotorPositionSwitch.on, offset: false)
                loadingVC.guessedWord = guessedWordTextField.text
                loadingVC.unmatchingWords = unmatchingParts
                loadingVC.ciphertext = encodedTextView.text
            }
        }
        (segue.destinationViewController as? UIViewController)?.popoverPresentationController?.delegate = self
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    var zoomRect: CGRect?

    
}
