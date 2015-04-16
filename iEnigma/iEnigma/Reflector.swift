//
//  Reflector.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
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
    private init(setting: [Int]) {
        pairs = setting
    }
    
    
    convenience init(type t: ReflectorType) {
        switch t {
        case .A:
            self.init(setting: [4, 9, 12, 25, 0, 11, 24, 23, 21, 1, 22, 5, 2, 17, 16, 20, 14, 13, 19, 18, 15, 8, 10, 7, 6, 3])
        case .B:
            self.init(setting: [24, 17, 20, 7, 16, 18, 11, 3, 15, 23, 13, 6, 14, 10, 12, 8, 4, 1, 5, 25, 2, 22, 21, 9, 0, 19])
        case .C:
            self.init(setting: [5, 21, 15, 9, 8, 0, 14, 24, 4, 3, 17, 25, 23, 22, 6, 2, 19, 10, 20, 16, 18, 1, 13, 12, 7, 11])
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
