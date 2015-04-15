//
//  RotorBombe.swift
//  Mnigma
//
//  Created by Leo Mehlig on 2/20/15.
//  Copyright (c) 2015 Leo Mehlig. All rights reserved.
//

import Foundation
class RotorBombe {
    private var plugboardTest: Enigma -> Plugboard? = { (_) in nil }
    var testRotors: Enigma -> Plugboard? {
        get {
            return plugboardTest
        }
        set {
            plugboardTest = newValue
            startBombe()
        }
    }
    var runningCount = 0 {
        didSet {
            if runningCount <= 0 {
                println(NSDate())
                running = false
            } else {
                running = true
            }
            
        }
    }
    
    var running = false
    var numberOfRotors: Int = 3 {
        didSet {
            rotorOrders = Rotor.RotorType.possibleOrders(numberOfRotors: numberOfRotors)
        }
    }
    lazy var rotorOrders: [[Rotor.RotorType]] = Rotor.RotorType.possibleOrders(numberOfRotors: self.numberOfRotors)
    
    var encodedString = ""
    var decodedString = ""
    
    func startBombe() {

        running = true
        forRotorPositions { (rotorPosition) in
            NSOperationQueue().addOperationWithBlock {
                self.runningCount++
               self.forRotorOrders { (rotorOrder) in
                 self.forReflectors { (reflector) in
                        let enigma = Enigma(ref: reflector, rotors: rotorOrder)
                        for rotor in enigma.rotors {
                            rotor.startRotorPosition = rotorPosition[rotor.rotorOrderNumber] ?? 0
                        }
                        if let p = self.plugboardTest(enigma) {
                            enigma.plugboard = p
                            enigma.rotor(0)?.resetRotor()
                            if enigma.encodeText(self.encodedString) != self.decodedString {
                                println("!!!FALSE PLUGBOARD SETTING!!!")
                            } else {
                                enigma.rotor(1)?.resetRotor()
                                println(enigma)
                            }
                        }

                    }
                }
                self.runningCount--
            }
        }
        
        
        
        
        
    }
    
    
    func forReflectors(call: (Reflector.ReflectorType) -> Void) {
        for ref in Reflector.ReflectorType.allTypes {
            call(ref)
        }
    }
    
    func forRotorOrders(call: ([Rotor.RotorType]) -> Void) {
        for rotorOrder in rotorOrders {
            call(rotorOrder)
        }
        
    }
    
    func forRotorPositions(call: ([Int: Int]) -> Void) {
        var rotorPositons = [Int: Int]()
        var stepNext = true
        while stepNext {
            call(rotorPositons)
            for idx in 0..<numberOfRotors {
                if stepNext {
                    rotorPositons[idx]  = (rotorPositons[idx] ?? 0) + 1
                    
                    if rotorPositons[idx] >= alphabet.count {
                        rotorPositons[idx] = 0
                        if idx < numberOfRotors - 1 {
                            stepNext = true
                            continue
                        } else {
                            stepNext = false
                            break
                        }
                        
                    }
                    stepNext == false
                }
                break
            }
        }
        
    }
    
    
}