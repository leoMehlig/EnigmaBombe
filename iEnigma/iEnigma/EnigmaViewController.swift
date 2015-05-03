//
//  EnigmaViewController.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnigmaViewController: UIViewController, UIPopoverPresentationControllerDelegate {
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
            if count(inputText) == count(oldValue) + 1 {
                keyboard.lightenKey(encodedText[advance(encodedText.endIndex, -1)])
            } else {
                keyboard.lightenKey(nil)
            }
            updateRotorPositionViews()
        }
    }
    var encodedText = "" {
        didSet {
            if encodedText != oldValue {
                encodeTextView.attributedText = attributedStrFromString(encodedText)
            }
        }
    }
    
    func reloadEncodedText() {
        for rotor in enigma.rotors { rotor.resetRotor() }
        encodedText = enigma.encodeText(inputText)
        updateRotorPositionViews()
    }
    
    @IBOutlet weak var inputTextView: UITextView! {
        didSet {
            inputTextView?.font = Constants.Design.BodyFont
            inputTextView?.backgroundColor = UIColor(patternImage: UIImage(named: "clean_paper_background.png")!)
//            inputTextView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        }
    }
    @IBOutlet weak var encodeTextView: UITextView! {
        didSet {
            encodeTextView?.font = Constants.Design.BodyFont
            encodeTextView?.backgroundColor = UIColor(patternImage: UIImage(named: "clean_paper_background.png")!)
//            encodeTextView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
            
        }
    }
    
//    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
//        if let textView = object as? UITextView where keyPath == "contentSize" {
//            let topCorrect = textView.bounds.size.height - textView.contentSize.height
//            textView.setContentOffset(CGPoint(x: 0, y: -topCorrect), animated: false)
//        }
//    }
//    
    private struct TextViewMenuItemActions {
        static let Share = Selector("shareEncodedText")
        static let Paste = Selector("pasteToInputView")
        static let Reset = Selector("resetText")
        static let Copy = Selector("copyText")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareMenuItem = UIMenuItem(title: "Share", action: TextViewMenuItemActions.Share)
        let pasteMenuItem = UIMenuItem(title: "Paste", action: TextViewMenuItemActions.Paste)
        let copyMenuItem = UIMenuItem(title: "Copy", action: TextViewMenuItemActions.Copy)
        let resetMenuItem = UIMenuItem(title: "Reset", action: TextViewMenuItemActions.Reset)
        UIMenuController.sharedMenuController().menuItems = [pasteMenuItem, resetMenuItem, shareMenuItem, copyMenuItem]
    }
    
    func shareEncodedText() {
        let activityVC = UIActivityViewController(activityItems: [encodedText], applicationActivities: nil)
        activityVC.title = "Share Enigma-Ciphertext"
        activityVC.popoverPresentationController?.sourceView = encodeTextView
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func pasteToInputView() {
        if let newText = UIPasteboard.generalPasteboard().string {
            inputText = Enigma.validateText(newText)
        }
    }
    
    func resetText() {
        inputText = ""
    }
    
    func copyText() {
        let text = tappedTextView?.text ?? encodedText
        UIPasteboard.generalPasteboard().string = text
    }
    
    private var tappedTextView: UITextView?
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        switch action {
        case TextViewMenuItemActions.Share:
            if tappedTextView == encodeTextView && !encodeTextView.text.isEmpty { return true }
        case TextViewMenuItemActions.Reset:
            if (tappedTextView == encodeTextView || tappedTextView == inputTextView) && !inputTextView.text.isEmpty { return true }
        case TextViewMenuItemActions.Paste:
            if tappedTextView == inputTextView { return true }
        case TextViewMenuItemActions.Copy:
            if tappedTextView != nil { return true }
        default: return super.canPerformAction(action, withSender: sender)
        }
        return false
    }
    
    private func attributedStrFromString(string: String) -> NSAttributedString {
        let font = Constants.Design.BodyFont
        return NSAttributedString(string: string, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: Constants.Design.Colors.DarkForeground, NSKernAttributeName: 2.0])
    }
    
    @IBAction func showMenuItem(sender: UITapGestureRecognizer) {
        if tappedTextView != nil && tappedTextView == sender.view as? UITextView && UIMenuController.sharedMenuController().menuVisible {
            return
        }
        tappedTextView = sender.view as? UITextView
        if let tappedView = tappedTextView {
            self.becomeFirstResponder()
            UIMenuController.sharedMenuController().setTargetRect(CGRect(x: 0, y: tappedView.contentOffset.y + 5, width: tappedView.bounds.width, height: 0), inView: tappedView)
            UIMenuController.sharedMenuController().setMenuVisible(true, animated: true)
        }
    }
    
    private func menuDidHide() {
        tappedTextView = nil
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
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
            rotorPositonViewI.rotorChanged = self.rotorPositionChanged
        }
    }
    @IBOutlet weak var rotorPositonViewII: EnigmaRotorPositionView! {
        didSet {
            rotorPositonViewII.rotorChanged = self.rotorPositionChanged
        }
    }
    @IBOutlet weak var rotorPositonViewIII: EnigmaRotorPositionView! {
        didSet {
            rotorPositonViewIII.rotorChanged = self.rotorPositionChanged
        }
    }
    
    func rotorPositionChanged(rotorView: EnigmaRotorPositionView, stepsAdded: Int) {
        let orderNumber = rotorView == rotorPositonViewI ? 0 : rotorView == rotorPositonViewII ? 1 : 2
        enigma.resetRotors()
        enigma.rotor(orderNumber)?.startRotorPosition += stepsAdded
        var newPositions = [Int]()
        for (idx, rp) in enumerate(EnigmaSettings.rotorPositions) {
            if idx == orderNumber {
                newPositions.append(enigma.rotor(orderNumber)?.startRotorPosition ?? rp)
            } else {
                newPositions.append(rp)
            }
        }
        EnigmaSettings.rotorPositions = newPositions
        reloadEncodedText()
        keyboard.lightenKey(nil)
        
    }
    private func updateRotorStartPositions() {
        let positions = EnigmaSettings.rotorPositions
        var changes = false
        for (idx, p) in enumerate(positions) {
            if enigma.rotor(idx)?.startRotorPosition != p {
                enigma.rotor(idx)?.startRotorPosition = p
                changes = true
            }
        }
        if changes { reloadEncodedText() }
    }
    private func updateRotorPositionViews() {
        rotorPositonViewI?.rotorPosition = enigma.rotor(0)?.rotorPosition ?? 0
        rotorPositonViewII?.rotorPosition = enigma.rotor(1)?.rotorPosition ?? 0
        rotorPositonViewIII?.rotorPosition = enigma.rotor(2)?.rotorPosition ?? 0
        
    }
    //MARK: - Setting
    var expandedSettingsView: UIView? {
        didSet {
            if expandedSettingsView != nil { keyboard.lightenKey(nil) }
            enigmaViewTapRecognizer.enabled = expandedSettingsView != nil
            reflectorButton.selected = expandedSettingsView == reflectorView
            if expandedSettingsView != rotorSettingView {
                deselectRotors()
            }
            
        }
    }
    @IBAction func collaspeSettingView(sender: UITapGestureRecognizer) {
        if expandedSettingsView != nil {
            swipeViewOut(toLeft: expandedSettingsView == plugboardView)
        }
    }
    
    @IBOutlet var enigmaViewTapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var settingBaseView: EnigmaFillingSubviewView!
    @IBOutlet weak var bottomConstaint: NSLayoutConstraint!
    @IBOutlet weak var settingsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var settingsTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var settingsLeadingConstraint: NSLayoutConstraint!
    var settingHeightWidthMultiplier: CGFloat { return CGFloat((self.traitCollection.horizontalSizeClass == .Compact ? 4 : 2.5)/13) }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (_) -> Void in
            if let v = self.expandedSettingsView {
                let height = size.width * self.settingHeightWidthMultiplier
                self.bottomConstaint.constant = -height
                self.settingsHeightConstraint.constant = height
                self.view.layoutIfNeeded()
            }
            }) { _ in }
    }
    
    func swipeViewIn(v: UIView, fromLeft: Bool) {
        let viewHeight = self.view.bounds.width * settingHeightWidthMultiplier
        settingBaseView.hidden = true
        if fromLeft {
            settingsLeadingConstraint.constant = -self.view.bounds.width
            settingsTrailingConstraint.constant = -self.view.bounds.width
        } else {
            settingsTrailingConstraint.constant = self.view.bounds.width
            settingsLeadingConstraint.constant = self.view.bounds.width
        }
        self.view.layoutIfNeeded()
        self.bottomConstaint.constant = -viewHeight
        settingsHeightConstraint.constant = viewHeight
        self.settingBaseView.addSubview(v)
        self.settingBaseView.clipsToBounds = true
        v.frame = self.settingBaseView.bounds
        v.frame.size.height = viewHeight
        v.setNeedsLayout()
        v.layoutIfNeeded()
        self.expandedSettingsView = v
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { fi in
                if fi {
                    v.frame = self.settingBaseView.bounds
                    
                    
                    if fromLeft {
                        self.settingsTrailingConstraint.constant = 0
                        self.settingsLeadingConstraint.constant = 0
                    } else {
                        self.settingsLeadingConstraint.constant = 0
                        self.settingsTrailingConstraint.constant = 0
                        
                    }
                    
                    self.settingBaseView.hidden = false
                    UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                        self.view.layoutIfNeeded()
                        }, completion: nil)
                }
                
        }
    }
    
    func swipeViewOut(#toLeft: Bool) {
        if toLeft {
            settingsLeadingConstraint.constant = -self.view.bounds.width
            settingsTrailingConstraint.constant = -self.view.bounds.width
        } else {
            settingsTrailingConstraint.constant = self.view.bounds.width
            settingsLeadingConstraint.constant = self.view.bounds.width
        }
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { fi in
                if fi {
                    self.settingsHeightConstraint.constant = 0
                    self.bottomConstaint.constant = 0
                    self.settingBaseView.hidden = true
                    for v in self.settingBaseView.subviews {
                        v.removeFromSuperview()
                    }
                    self.expandedSettingsView = nil
                    if toLeft {
                        self.settingsTrailingConstraint.constant = 0
                        self.settingsLeadingConstraint.constant = 0
                    } else {
                        self.settingsLeadingConstraint.constant = 0
                        self.settingsTrailingConstraint.constant = 0
                    }
                    UIView.animateWithDuration(0.1) {
                        self.view.layoutIfNeeded()
                    }
                }
        }
    }
    
    func flipView(v: UIView, toView: UIView) {
        toView.frame = settingBaseView.bounds
        toView.clipsToBounds = true
        UIView.transitionFromView(v, toView: toView, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
        self.expandedSettingsView = toView
    }
    
    //MARK: - Plugboard
    
    @IBOutlet weak var plugboardLabel: UILabel! {
        didSet {
            updatePlugboardLabel()
        }
    }
    
    func updatePlugboardLabel() {
        let plgStr = EnigmaDisplayer.Plugboard(EnigmaSettings.plugboard)
        if plgStr != plugboardLabel.text {
            enigma.plugboard = Plugboard(settings: EnigmaSettings.plugboard)
            reloadEncodedText()
        }
        plugboardLabel?.text = plgStr
    }
    
    lazy var plugboardView = EnimgaPlugboardSettingsView()
    @IBAction func plugboardTapped(sender: UITapGestureRecognizer) {
        if let currentSettingView = expandedSettingsView {
            if currentSettingView == plugboardView {
                swipeViewOut(toLeft: true)
            } else {
                flipView(currentSettingView, toView: plugboardView)
                
            }
        } else {
            swipeViewIn(plugboardView, fromLeft: true)
        }
    }
    
    
    //MARK: - Reflector
    lazy var reflectorView = EnigmaReflectorSettingView()
    @IBOutlet weak var reflectorButton: EnigmaReflectorButton! {
        didSet {
            updateReflector()
        }
    }
    func updateReflector() {
        let ref = EnigmaSettings.reflector
        let newLetter = EnigmaDisplayer.Reflector(ref)
        if reflectorButton?.letter != newLetter {
            enigma.reflector = Reflector(type: Reflector.ReflectorType(rawValue: ref)!)
            reloadEncodedText()
        }
        reflectorButton?.letter = newLetter
        
    }
    
    @IBAction func reflectorTapped(sender: EnigmaReflectorButton) {
        if let currentSettingView = expandedSettingsView {
            if currentSettingView == reflectorView {
                swipeViewOut(toLeft: false)
            } else {
                flipView(currentSettingView, toView: reflectorView)
            }
        } else {
            swipeViewIn(reflectorView, fromLeft: false)
        }
    }
    
    
    //MARK: - RotorSettings
    @IBOutlet weak var rotor1: EnigmaRotorSettingButton! {
        didSet {
            rotor1?.rotorType = .EnigmaRotor(orderNumber: 0)
        }
    }
    
    @IBOutlet weak var rotor2: EnigmaRotorSettingButton! {
        didSet {
            rotor2?.rotorType = .EnigmaRotor(orderNumber: 1)
        }
    }
    
    @IBOutlet weak var rotor3: EnigmaRotorSettingButton! {
        didSet {
            rotor3?.rotorType = .EnigmaRotor(orderNumber: 2)
        }
    }
    
    func updateRotors() {
        rotor1?.updateText()
        rotor2?.updateText()
        rotor3?.updateText()
        enigma = EnigmaSettings.enigmaFromSettings
        reloadEncodedText()
    }
    
    func updateOffset() {
        var changes = false
        for (idx, offset) in enumerate(EnigmaSettings.rotorOffset) {
            if enigma.rotor(idx)?.offsetPosition != offset {
                enigma.rotor(idx)?.offsetPosition = offset
                changes = true
            }
        }
        if changes { reloadEncodedText() }
    }
    
    func deselectRotors() {
        rotor1.selected = false
        rotor2.selected = false
        rotor3.selected = false
    }
    
    func selectRotor(orderNumber: Int) {
        switch orderNumber {
        case 0: rotor1.selected = true
        case 1: rotor2.selected = true
        case 2: rotor3.selected = true
        default: break
        }
    }
    
    lazy var rotorSettingView = EnigmaRotorSettingView()
    @IBAction func rotorSettingsButtonTapped(sender: EnigmaRotorSettingButton) {
        let orderNumber: Int
        switch sender.rotorType! {
        case .EnigmaRotor(let num):
            orderNumber = num
        default: return
        }
        deselectRotors()
        selectRotor(orderNumber)
        if let currentSettingView = expandedSettingsView {
            if currentSettingView == rotorSettingView {
                if rotorSettingView.rotorOrderNumber == orderNumber {
                    swipeViewOut(toLeft: false)
                } else {
                    rotorSettingView.rotorOrderNumber = orderNumber
                }
            } else {
                rotorSettingView.rotorOrderNumber = orderNumber
                flipView(currentSettingView, toView: rotorSettingView)
            }
        } else {
            rotorSettingView.rotorOrderNumber = orderNumber
            swipeViewIn(rotorSettingView, fromLeft: false)
        }
    }
    
    var rotorObserver: NSObjectProtocol?
    var plugboardObserver: NSObjectProtocol?
    var reflectorObserver: NSObjectProtocol?
    var menuObserver: NSObjectProtocol?
    var offsetObserver: NSObjectProtocol?
    var positionObserver: NSObjectProtocol?

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.rotorObserver = NSNotificationCenter.defaultCenter().addObserverForName(EnigmaSettings.Notifications.Rotors, object: nil, queue: nil) { _ in
            self.updateRotors()
        }
        plugboardObserver = NSNotificationCenter.defaultCenter().addObserverForName(EnigmaSettings.Notifications.Plugboard, object: nil, queue: nil) { [unowned self] _ in
            self.updatePlugboardLabel()
        }
        self.reflectorObserver = NSNotificationCenter.defaultCenter().addObserverForName(EnigmaSettings.Notifications.Reflector, object: nil, queue: nil) { _ in
            self.updateReflector()
        }
        
        offsetObserver = NSNotificationCenter.defaultCenter().addObserverForName(EnigmaSettings.Notifications.Offset, object: nil, queue: nil) { _ in
            self.updateOffset()
        }
        positionObserver = NSNotificationCenter.defaultCenter().addObserverForName(EnigmaSettings.Notifications.Positon, object: nil, queue: nil) { _ in
            self.updateRotorStartPositions()
        }
        self.updateRotorStartPositions()
        
        menuObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIMenuControllerDidHideMenuNotification, object: nil, queue: nil) { _ in
            self.menuDidHide()
        }
        self.inputText = EnigmaSettings.inputText
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        EnigmaSettings.inputText = self.inputText
        if rotorObserver != nil { NSNotificationCenter.defaultCenter().removeObserver(rotorObserver!) }
        if plugboardObserver != nil { NSNotificationCenter.defaultCenter().removeObserver(plugboardObserver!) }
        if reflectorObserver != nil { NSNotificationCenter.defaultCenter().removeObserver(reflectorObserver!) }
        if offsetObserver != nil { NSNotificationCenter.defaultCenter().removeObserver(offsetObserver!) }
        if positionObserver != nil { NSNotificationCenter.defaultCenter().removeObserver(positionObserver!) }

        if menuObserver != nil { NSNotificationCenter.defaultCenter().removeObserver(menuObserver!) }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as? UIViewController)?.popoverPresentationController?.delegate = self
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
