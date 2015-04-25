//
//  EnigmaDisplayer.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/25/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

struct EnigmaDisplayer {
    static func Rotors(intAry: [Int]) -> String {
        let rotors = intAry.map { $0 == 0 ? "I" : $0 == 1 ? "II" : $0 == 2 ? "III" : "?" }
        return rotors.reduce("") {
            var new = $0 ?? ""
            if !new.isEmpty {
                new += ", "
            }
            return new + $1
        }
    }
    
    static func Rotors(enigma: Enigma) -> String {
        return enigma.rotors.reduce("") {
            var new = $0 ?? ""
            if !new.isEmpty {
                new += ", "
            }
            return new + ($1.rotorSetting.type?.description ?? "?")
        }
    }
    
    static func RotorPositions(intAry: [Int]) -> String {
        return intAry.reduce("") {
            var new = $0 ?? ""
            if !new.isEmpty {
                new += ", "
            }
            var p = $1
            while p >= alphabet.count {
                p -= alphabet.count
            }
            while p < 0 {
                p += alphabet.count
            }
            return new + String(alphabet[p])
        }
    }
    
    static func RotorPositions(enigma: Enigma) -> String {
        return enigma.rotors.reduce("") {
            var new = $0 ?? ""
            if !new.isEmpty {
                new += ", "
            }
            var p = $1.startRotorPosition
            while p >= alphabet.count {
                p -= alphabet.count
            }
            while p < 0 {
                p += alphabet.count
            }
            return new + String(alphabet[p])
        }
    }
    
    static func RotorOffsets(intAry: [Int]) -> String {
        return intAry.reduce("") {
            var new = $0 ?? ""
            if !new.isEmpty {
                new += ", "
            }
            var o = $1
            while o >= alphabet.count {
                o -= alphabet.count
            }
            while o < 0 {
                o += alphabet.count
            }
            return new + String(alphabet[o])
        }
    }
    
    static func RotorOffsets(enigma: Enigma) -> String {
        return enigma.rotors.reduce("") {
            var new = $0 ?? ""
            if !new.isEmpty {
                new += ", "
            }
            var o = $1.offsetPosition
            while o >= alphabet.count {
                o -= alphabet.count
            }
            while o < 0 {
                o += alphabet.count
            }
            return new + String(alphabet[o])
        }
    }
    
    static func Reflector(i: Int) -> Character {
        return alphabet[i]
    }
    
    static func Reflector(enigma: Enigma) -> String {
        return enigma.reflector.type?.description ?? "?"
    }
    
    static func Plugboard(pairs: [PlugboardPair]) -> String {
        var filtersPlugboard = pairs.filter {
           return $0.letter1 != $0.letter2
        }
        let plugboard = filtersPlugboard.sorted {
            let i1 = idxAlphabet[$0.letter1]!
            let i2 = idxAlphabet[$0.letter2]!
            let n1 = idxAlphabet[$1.letter1]!
            let n2 = idxAlphabet[$1.letter2]!
            let i = i1 < i2 ? i1 : i2
            let n = n1 < n2 ? n1 : n2
            return i < n
        }
        var plgStr = ""
        for pair in plugboard  {
            if pair.letter1 != pair.letter2 {
                if idxAlphabet[pair.letter1] < idxAlphabet[pair.letter2] {
                    plgStr += "\(pair.letter1)\(pair.letter2) "
                } else {
                    plgStr += "\(pair.letter2)\(pair.letter1) "
                }
            }
        }

        return !plgStr.isEmpty ? plgStr : "Empty"
    }
}
