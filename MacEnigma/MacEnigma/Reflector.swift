//
//  Reflector.swift
//  Enigma
//
//  Created by Leo Mehlig on 2/7/15.
//  Copyright (c) 2015 Leo Mehlig. All rights reserved.
//

import Foundation

struct ReflectorPair: Printable {
    let letter1: Character
    let letter2: Character
    let position1: Int
    let position2: Int
    init(_ l1: Character, _ l2: Character){
        letter1 = l1
        letter2 = l2
        position1 = idxAlphabet[l1] ?? 0
        position2 = idxAlphabet[l2] ?? 0
        
    }
    
    var description: String {
        return "\(letter1)\(letter2)"
    }
}



class Reflector: Printable {
    enum ReflectorType: Int, Printable {
        case A = 0, B, C
        
        var description: String {
            switch self {
            case .A:
                return "A"
            case .B:
                return "B"
            case .C:
                return "C"
            }
        }
        static var allTypes: [ReflectorType] = {
            var types = [ReflectorType]()
            while true {
                if let t = ReflectorType(rawValue: types.count) {
                    types.append(t)
                } else {
                    break
                }
            }
            return types
        }()
    }
    
    var type: ReflectorType?
    let pairs: [Int]
    private init(setting: [ReflectorPair]) {
        var temp = [Int](count: 26, repeatedValue: 0)
        for p in setting {
            temp.replaceRange(p.position1..<p.position1+1, with: [p.position2])
            temp.replaceRange(p.position2..<p.position2+1, with: [p.position1])

        }
        pairs = temp
    }
    
    
    convenience init(type t: ReflectorType) {
        switch t {
        case .A:
            self.init(setting: [ReflectorPair("e", "a"), ReflectorPair("j", "b"), ReflectorPair("m", "c"), ReflectorPair("z", "d"), ReflectorPair("l", "f"), ReflectorPair("y", "g"), ReflectorPair("x", "h"), ReflectorPair("v", "i"), ReflectorPair("w", "k"), ReflectorPair("r", "n"), ReflectorPair("q", "o"), ReflectorPair("u", "p"), ReflectorPair("t", "s")])
        case .B:
            self.init(setting: [ReflectorPair("y", "a"), ReflectorPair("r", "b"), ReflectorPair("u", "c"), ReflectorPair("h", "d"), ReflectorPair("q", "e"), ReflectorPair("s", "f"), ReflectorPair("l", "g"), ReflectorPair("p", "i"), ReflectorPair("x", "j"), ReflectorPair("n", "k"), ReflectorPair("o", "m"), ReflectorPair("z", "t"), ReflectorPair("w", "v")])
        case .C:
            self.init(setting: [ReflectorPair("f", "a"), ReflectorPair("v", "b"), ReflectorPair("p", "c"), ReflectorPair("j", "d"), ReflectorPair("i", "e"), ReflectorPair("o", "g"), ReflectorPair("y", "h"), ReflectorPair("r", "k"), ReflectorPair("z", "l"), ReflectorPair("x", "m"), ReflectorPair("w", "n"), ReflectorPair("t", "q"), ReflectorPair("u", "s")])
        }
        type = t

    }
    
    func encodePosition(i: Int) -> Int {
        var n = i
        while n < 0 {
            n += alphabet.count
        }
        while n >= alphabet.count {
            n -= alphabet.count
        }
        return pairs[n]

    }
    
    var description: String {
        if let t = type {
            return "\(t)"
        } else {
            var des = ""
            for char in alphabet {
                for p in pairs {
                    des += String(p)
                }
            }
            return des
        }
    }
}
