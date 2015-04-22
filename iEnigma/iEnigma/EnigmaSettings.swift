//
//  EnigmaSettings.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/16/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import Foundation

struct EnigmaSettings {
    private struct Keys {
        static let rotors = "rotor"
        static let rotorPositons = "rp"
        static let rotorOffset = "ro"
        static let reflector = "ref"
        static let plugboard = "plg"
    }
    
    struct Notifications {
        static let rotorPositonChanged = ["r1not", "r2not", "r3not"]
        static let rotorPositonOldValue = "rPold"
        static let plugboardChanged = "plgchange"
        static let Reflector = "refNot"
        static let Offset = "offnot"
        static let Rotors = "ronot"
    }
    
    private static var userDefault: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    static var enigmaFromSettings: Enigma {
        let enigma = Enigma(ref: Reflector.ReflectorType(rawValue: reflector)!, rotors: rotors.map { Rotor.RotorType(rawValue: $0)! })
        let positions = rotorPositions
        let offset = rotorOffset
        for (idx, rotor) in enumerate(enigma.rotors) {
            if positions.count > idx { rotor.rotorPosition = positions[idx] }
            if offset.count > idx { rotor.offsetPosition = offset[idx] }
        }
        enigma.plugboard = Plugboard(settings: plugboard)
        return enigma
    }
    
    static var rotors: [Int] {
        get {
        return userDefault.objectForKey(Keys.rotors) as? [Int] ?? [0, 1, 2]
        }
        set {
            let rs = rotors
            userDefault.setObject(newValue, forKey: Keys.rotors)
            for (idx, r) in enumerate(rs) {
                if idx < newValue.count  {
                    if newValue[idx] != r {
                       NSNotificationCenter.defaultCenter().postNotificationName(Notifications.Rotors, object: nil)
                    }
                }
            }
        }
        
    }
    
    static var rotorPositions: [Int] {
        get {
        return userDefault.objectForKey(Keys.rotorPositons) as? [Int] ?? [0, 0, 0]
        }
        set {
            let rp = rotorPositions
            userDefault.setObject(newValue, forKey: Keys.rotorPositons)
            for (idx, p) in enumerate(rp) {
                if idx < newValue.count  {
                    if newValue[idx] != p {
                        if idx < Notifications.rotorPositonChanged.count {
                            NSNotificationCenter.defaultCenter().postNotificationName(Notifications.rotorPositonChanged[idx], object: nil, userInfo: [Notifications.rotorPositonOldValue: p])
                        }
                    }
                }
            }
            
        }
    }
    
    static var rotorOffset: [Int] {
        get {
        return userDefault.objectForKey(Keys.rotorOffset) as? [Int] ?? [0, 0, 0]
        }
        set {
            let ro = rotorOffset
            userDefault.setObject(newValue, forKey: Keys.rotorOffset)
            for (idx, o) in enumerate(ro) {
                if idx < newValue.count  {
                    if newValue[idx] != o {
                        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.Offset, object: nil)
                    }
                }
            }
        }
    }
    
    static var reflector: Int {
        get {
        return userDefault.objectForKey(Keys.reflector) as? Int ?? 1
        }
        set {
            let oldValue = reflector
            userDefault.setObject(newValue, forKey: Keys.reflector)
            if oldValue != newValue {
                NSNotificationCenter.defaultCenter().postNotificationName(Notifications.Reflector, object: nil)
            }
        }
    }
    
    static var plugboard: [PlugboardPair] {
        get {
        return (userDefault.objectForKey(Keys.plugboard) as? [String])?.map { PlugboardPair($0[$0.startIndex], $0[advance($0.startIndex, 1)]) } ?? []
        }
        set {
            userDefault.setObject(newValue.map { "\($0.letter1)\($0.letter2)" }, forKey: Keys.plugboard)
            NSNotificationCenter.defaultCenter().postNotificationName(Notifications.plugboardChanged, object: nil)
        }
    }
    
}
class PairBox {
    private let letter1: String
    private let letter2: String
    init(_ plg: PlugboardPair) {
        letter1 = String(plg.letter1)
        letter2 = String(plg.letter2)
    }
    
    var plgPair: PlugboardPair {
        return PlugboardPair(letter1[letter1.startIndex], letter2[letter2.startIndex])
    }
}
class Box<T> {
    let content: T
    init(_ t: T) {
        content = t
    }
}