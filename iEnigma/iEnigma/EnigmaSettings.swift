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
        static let rotors = "ro"
        static let rotorPositons = "rp"
        static let rotorOffset = "ro"
        static let reflector = "ref"
        static let plugboard = "plg"
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
            userDefault.setObject(newValue, forKey: Keys.rotors)
        }
    }
    
    static var rotorPositions: [Int] {
        get {
            return userDefault.objectForKey(Keys.rotorPositons) as? [Int] ?? [0, 0, 0]
        }
        set {
            userDefault.setObject(newValue, forKey: Keys.rotorPositons)
        }
    }
    
    static var rotorOffset: [Int] {
        get {
            return userDefault.objectForKey(Keys.rotorOffset) as? [Int] ?? [0, 0, 0]
        }
        set {
            userDefault.setObject(newValue, forKey: Keys.rotorOffset)
        }
    }
    
    static var reflector: Int {
        get {
            return userDefault.objectForKey(Keys.reflector) as? Int ?? 1
        }
        set {
            userDefault.setObject(newValue, forKey: Keys.reflector)
        }
    }
    
    static var plugboard: [PlugboardPair] {
        get {
            return (userDefault.objectForKey(Keys.plugboard) as? [Box<PlugboardPair>])?.map { $0.content } ?? []
        }
        set {
            userDefault.setObject(newValue.map { Box($0) }, forKey: Keys.plugboard)
            
        }
    }
    
}

class Box<T> {
    let content: T
    init(_ t: T) {
        content = t
    }
}