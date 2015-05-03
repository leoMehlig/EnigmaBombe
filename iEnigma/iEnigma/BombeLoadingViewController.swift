//
//  BombeLoadingViewController.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/24/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class BombeLoadingViewController: UIViewController, BombeCompletionDelegate, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var drum: BombeDrumButton!
    var bombe: Bombe? {
        didSet {
            bombe?.delegate = self
        }
    }
    var guessedWord: String?
    var unmatchingWords: [Bombe.StringWithLocation]?
    var ciphertext: String?
    var timer: NSTimer?
    lazy var resultEnigmasWithText = [(Enigma, String)]()
    private func startAnimation() {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: "rotate:", userInfo: nil, repeats: true)
    }
    func rotate(timer: NSTimer) {
        self.drum.rotateOneLetter()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let unmatching = unmatchingWords where unmatching.count > 0 && guessedWord != nil && bombe != nil {
            bombe?.startBombeWithWord(guessedWord!, decryptedWords: unmatching)
            startAnimation()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if bombe?.stopped == false && timer == nil {
            startAnimation()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
        bombe?.stopped = true
    }
    
    
    
    func completedAll() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.timer?.invalidate()
            self.timer = nil
            self.drum.contentText = "100%"
            if self.resultEnigmasWithText.isEmpty {
                let alert = UIAlertController(title: "No Enigma settings found", message: "Please change your Bombe settings or guess another word", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { _ in
                    self.navigationController?.popViewControllerAnimated(true)
                    })
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func completedWord(word: Bombe.StringWithLocation) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
        }
    }
    
    func completedRotorOrder(order: [Rotor.RotorType], forWord: Bombe.StringWithLocation) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
        }
    }
    
    func completedReflector(ref: Reflector.ReflectorType, forRotorOrder: [Rotor.RotorType], forWord: Bombe.StringWithLocation) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
        }
    }
    
    func shouldContinueAfterFindingEnigma(enigma: Enigma) -> Bool {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            let text = enigma.encodeText(self.ciphertext ?? "")
            enigma.resetRotors()
            self.resultEnigmasWithText.append((enigma, text))
            self.resultTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.resultEnigmasWithText.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
        }
        return true
    }
    
    func progressDidChange(newProgress: Int) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.drum.contentText = "\(newProgress)%"
        }
    }
    
    func stopped() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.timer?.invalidate()
            self.timer = nil
            self.drum.contentText = "Stopped"
        }
    }
    
    
    //MARK: - TabelView
    
    @IBOutlet weak var resultTableView: UITableView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resultCell") as! UITableViewCell
        (cell.viewWithTag(100) as? UILabel)?.text = indexPath.row < resultEnigmasWithText.count ? resultEnigmasWithText[indexPath.row].1 : ""
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultEnigmasWithText.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < resultEnigmasWithText.count {
            (EnigmaSettings.enigmaFromSettings, EnigmaSettings.inputText) = resultEnigmasWithText[indexPath.row]
            let alert = UIAlertController(title: "The new Enigma Setting got set", message: "Do you want to return to the start screen", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { _ in
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel){ _ in })
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "enigmaDetail" {
            (segue.destinationViewController as? UIViewController)?.popoverPresentationController?.delegate = self
            if let cell = sender as? UITableViewCell {
                (segue.destinationViewController as? UIViewController)?.popoverPresentationController?.sourceRect = cell.convertRect(CGRect(x: max(cell.bounds.width - 50, 0), y: 0, width: 50, height: cell.bounds.height), toView: resultTableView)

                if let idx = resultTableView.indexPathForCell(cell)?.row {
                    if let des = segue.destinationViewController as? BombeEnigmaDetailsTableViewController {
                        if idx < resultEnigmasWithText.count {
                            let result = resultEnigmasWithText[idx]
                            des.decryptedText = result.1
                            des.enigma = result.0
                        }
                    }
                }
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
}
