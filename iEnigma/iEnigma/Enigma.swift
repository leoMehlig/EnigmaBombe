//
//  Enigma.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import Foundation

let alphabet: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

let idxAlphabet: [Character: Int] = ["A": 0, "B": 1, "C": 2, "D": 3, "E": 4, "F": 5, "G": 6, "H": 7, "I": 8, "J": 9, "K": 10, "L": 11, "M": 12, "N": 13, "O": 14, "P": 15, "Q": 16, "R": 17, "S": 18, "T": 19, "U": 20, "V": 21, "W": 22, "X": 23, "Y": 24, "Z": 25]


class Enigma: Printable {
    
    let rotors: [Rotor]
    func rotor(idx: Int) -> Rotor? {
        if rotors.count > idx {
            return rotors[idx]
        }
        return nil
    }
    lazy var plugboard: Plugboard = Plugboard()
    var reflector: Reflector
    
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
            Enigma.validateText(text)
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
    
    
    class func validateText(text: String) -> String {
        
        let t = text.uppercaseString
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
    func resetRotors() {
        for rotor in rotors {
            rotor.rotorPosition = rotor.startRotorPosition
        }
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
