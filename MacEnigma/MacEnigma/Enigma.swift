//
//  Enigma.swift
//  Enigma
//
//  Created by Leo Mehlig on 2/8/15.
//  Copyright (c) 2015 Leo Mehlig. All rights reserved.
//

import Foundation

let alphabet: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

let idxAlphabet: [Character: Int] = ["a": 0, "b": 1, "c": 2, "d": 3, "e": 4, "f": 5, "g": 6, "h": 7, "i": 8, "j": 9, "k": 10, "l": 11, "m": 12, "n": 13, "o": 14, "p": 15, "q": 16, "r": 17, "s": 18, "t": 19, "u": 20, "v": 21, "w": 22, "x": 23, "y": 24, "z": 25]


class Enigma: Printable {
    
    let rotors: [Rotor]
    func rotor(idx: Int) -> Rotor? {
        if rotors.count > idx {
            return rotors[idx]
        }
        return nil
    }
    var plugboard: Plugboard = Plugboard()
    let reflector: Reflector
    
    init(ref: Reflector.ReflectorType, rotors rotorTypes: [Rotor.RotorType]) {
        var tempRotors = [Rotor]()
        for (idx, type) in enumerate(rotorTypes) {
            tempRotors.append(Rotor(type: type, orderNumber: idx))
        }
        rotors = tempRotors
        reflector = Reflector(type: ref)
        for (idx, currentRotor) in enumerate(rotors) {
            if let nextRotor = rotor(idx+1) {
                currentRotor.turnoverCallback = { $0 ? nextRotor.step() : nextRotor.stepBack() }
                currentRotor.nextRotor = nextRotor
            }
        }
        
    }
    
    convenience init(ref: Reflector.ReflectorType, rotors rotorTypes: Rotor.RotorType...) {
        self.init(ref: ref, rotors: rotorTypes)
    }
    
    func encodeText(text: String, needsValidation: Bool = true) -> String {
        var inputText = text
        if needsValidation {
            validateText(text)
        }
        var encodedText = ""
        
        for char in inputText {
            encodedText += String(encodeLetter(char))
        }
        return encodedText
    }
    
    func encodeLetter(letter: Character, usePlugboard pl: Bool = true) -> Character {
        //Step
        rotor(0)?.step()
       rotor(1)?.stepSecondRotorIfNeeded()
        
        //Encoding
        var position = 0
        if pl {
            position = plugboard.encodeLetter(letter)
        } else {
            position = idxAlphabet[letter]!
        }
        for rotor in rotors {
            position = rotor.encodePosition(position)
        }
        position = reflector.encodePosition(position)
        for rotor in reverse(rotors) {
            position = rotor.reverseEncodePosition(position)
        }
        if pl {
            return plugboard.encodePosition(position)
        } else {
            while position < 0 {
                position += alphabet.count
            }
            while position >= alphabet.count {
                position -= alphabet.count
            }
            return alphabet[position]
        }
    }
    
    
    func validateText(text: String) -> String {
        
        let t = NSString(string: text).lowercaseString as String
        var validText = ""
        for c in t {
            for char in alphabet {
                if char == c {
                    validText += String(c)
                }
            }
        }
        return validText
    }
    var description: String {
        var s = "Plugboard: \(plugboard)\nRotors: "
        for (idx, rotor) in enumerate(rotors) {
            if idx != 0 {
                s += "\t\t"
            }
            s += "\(rotor)\n"
        }
        s += "Reflector: \(reflector)"
        return s
    }
    
    
    
}
