//
//  ViewController.swift
//  MacEnigma
//
//  Created by Leo Mehlig on 2/21/15.
//  Copyright (c) 2015 Leo Mehlig. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotorb()
        
    }
    func creatPossibleOrders(values: [Int]) -> [[Int]] {
        var possibleOrders = [[Int]]()
        for (idx, val) in enumerate(values) {
            var newValues = values
            newValues.removeAtIndex(idx)
            if newValues.count > 0 {
                for order in creatPossibleOrders(newValues) {
                    possibleOrders.append([val] + order)
                }
            } else {
                possibleOrders.append([val])
            }
            
        }
        return possibleOrders
    }
    
    func loop() {
        let testText = "wearethewatchersonthewall"
        let enigma = Enigma(ref: .A, rotors: .I, .II, .III)
        let encodedText = enigma.encodeText(testText)
        
        if let loops = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: testText, decodedStr: encodedText) {
            for (loop, range, closed) in loops {
                println(loop)
                println(range)
                println(closed)
            }
        }
        
    }
    func pb() {
        let testText = "wearethewatchersonthewall"
        let enigma = Enigma(ref: .C, rotors: .II, .I, .III)
        enigma.rotor(0)?.rotorPositionLetter = "f"
        enigma.rotor(1)?.rotorPositionLetter = "q"
        enigma.rotor(2)?.rotorPositionLetter = "c"
        //        enigma.rotorI.offsetLetter = "d"
        //        enigma.rotorII.offsetLetter = "g"
        //        enigma.rotorIII.offsetLetter = "k"
        enigma.plugboard.pairs = [PlugboardPair("a","v"), PlugboardPair("d", "m"), PlugboardPair("f", "t"), PlugboardPair("h", "i"), PlugboardPair("k", "o"), PlugboardPair("p", "s"), PlugboardPair("q", "x"), PlugboardPair("r", "w")]
        let encodedText = enigma.encodeText(testText)
        
        let bombe = PlugboardBombe(enigma: enigma)
        if let loops = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: testText, decodedStr: encodedText) {
            for loop in loops {
                println(loop)
            }
            println(bombe.plugboardForLoops(loops, text: testText, enText: encodedText))
        }
        
    }
    func rotorb() {
        let startDate = NSDate()
        println(NSDate())
        let testText = "wearethewatchersonthewall"
        let enigma = Enigma(ref: .C, rotors: .II, .II, .I)
        enigma.rotor(0)?.rotorPositionLetter = "f"
        enigma.rotor(1)?.rotorPositionLetter = "q"
        enigma.rotor(2)?.rotorPositionLetter = "c"
//                enigma.rotorI.offsetLetter = "d"
//                enigma.rotorII.offsetLetter = "g"
//                enigma.rotorIII.offsetLetter = "k"
        enigma.plugboard.pairs = [PlugboardPair("y","v"), PlugboardPair("d", "m"), PlugboardPair("f", "t"), PlugboardPair("h", "i"), PlugboardPair("k", "o"), PlugboardPair("p", "s"), PlugboardPair("q", "x"), PlugboardPair("r", "w")]
        let bombe = PlugboardBombe(enigma: enigma)
        let encodedText = enigma.encodeText(testText)
    
        if let loops = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: testText, decodedStr: encodedText) {
            for loop in loops {
                println(loop)
            }
            println(encodedText)
            let rb = RotorBombe()
            rb.encodedString = testText
            rb.decodedString = encodedText
            rb.testRotors = { (e) in
                let bombe = PlugboardBombe(enigma: e)
                return bombe.plugboardForLoops(loops, text: testText, enText: encodedText)
                
            }
            while rb.running { }
            println(NSDate())
            println(startDate.timeIntervalSinceNow)
        }
        
    }
    
    
    
}

