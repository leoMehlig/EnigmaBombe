//
//  Plugboard.swift
//  Enigma
//
//  Created by Leo Mehlig on 2/7/15.
//  Copyright (c) 2015 Leo Mehlig. All rights reserved.
//

import Foundation

func == (leftPair: PlugboardPair, rightPair: PlugboardPair) -> Bool {
    if leftPair.letter1 == rightPair.letter1 && leftPair.letter2 == rightPair.letter2 { return true }
    if leftPair.letter1 == rightPair.letter2 && leftPair.letter2 == rightPair.letter1 { return true }
    return false
}

struct PlugboardPair: Printable {
    let letter1: Character
    let letter2: Character
    init(_ l1: Character, _ l2: Character) {
        letter1 = l1
        letter2 = l2
    }
    
    func containsLetter(c: Character) -> Character? {
        if letter1 == c {
            return letter2
        } else if letter2 == c {
            return letter1
        }
        return nil
    }
    
    var description: String {
        return "\(letter1)\(letter2)"
    }
}
class Plugboard: Printable {
    var pairs: [PlugboardPair]
    
    init(settings: [PlugboardPair]) {
        pairs = Plugboard.validatePairs(settings)
    }
    
    class func validatePairs(pairs: [PlugboardPair]) -> [PlugboardPair] {
        var validPairs = [PlugboardPair]()
        pairLoop: for p in pairs {
            if p.letter1 == p.letter2 { continue }
            for otherP in validPairs {
                if otherP == p {
                    continue pairLoop
                }
            }
            validPairs.append(p)
        }
        return validPairs
    }
    convenience init() {
        self.init(settings: [])
    }
    
    func encodeLetter(input: Character) -> Int {
        var ec: Character = input
        for p in pairs {
            if p.letter1 == input {
                ec = p.letter2
            } else if p.letter2 == input {
                ec = p.letter1
            }
        }
        for (idx, char) in enumerate(alphabet) {
            if ec == char {
                return idx
            }
        }
        return 0
        
    }
    
    func encodePosition(i: Int) -> Character {
        var n = i
        while n < 0 {
            n += alphabet.count
        }
        while n >= alphabet.count {
            n -= alphabet.count
        }
        var c = alphabet[n]
        for p in pairs {
            if p.letter1 == c {
                return p.letter2
            } else if p.letter2 == c {
                return p.letter1
            }
        }
        return c
    }
    
    var description: String {
        var des = ""
        for p in pairs {
            if count(des) > 0 {
                des += " "
            }
            des += "\(p)"
        }
        return des
    }
    
}
