//
//  Sequences.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/24/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import Foundation

class RotorSequence: SequenceType {
    let rotorOrders: [[Rotor.RotorType]]
    var count: Int {
        return rotorOrders.count
    }
    init(onlySetting: Bool) {
        if onlySetting {
            rotorOrders = [EnigmaSettings.rotors.map { Rotor.RotorType(rawValue: $0)! }]
        } else {
            rotorOrders = Rotor.RotorType.possibleOrders(numberOfRotors: 3)
        }
    }
    func generate() -> GeneratorOf<[Rotor.RotorType]> {
        var idx = 0
        return GeneratorOf {
            if idx < self.rotorOrders.count {
                idx++
                return self.rotorOrders[idx - 1]
            } else {
                return nil
            }
        }
    }
}

class ReflectorSequence: SequenceType {
  
    let reflectors: [Reflector.ReflectorType]
    var count: Int {
        return reflectors.count
    }
    init(onlySetting: Bool) {
        if onlySetting {
            reflectors = [Reflector.ReflectorType(rawValue: EnigmaSettings.reflector)!]
        } else {
            reflectors = Reflector.ReflectorType.allTypes
        }
    }
    func generate() -> GeneratorOf<Reflector.ReflectorType> {
        var idx = 0
        return GeneratorOf {
            if idx < self.reflectors.count {
                idx++
                return self.reflectors[idx - 1]
            } else {
                return nil
            }
        }
    }
}

class PositionOffsetSequence: SequenceType {
    private let settingOnlyVal: [Int]?
    var count: Int {
        if settingOnlyVal != nil {
            return 1
        } else {
            return alphabet.count * alphabet.count * alphabet.count
        }
    }
    init(onlySettingValue: [Int]?) {
        settingOnlyVal = onlySettingValue
    }
    func generate() -> GeneratorOf<[Int]> {
        if let val = settingOnlyVal {
            var first = true
            return GeneratorOf {
                if first {
                    first = false
                    return val
                }
                return nil
            }
        } else {
            var ary = [0, 0, 0]
            return GeneratorOf {
                let oldValue = ary
                for i in 0...ary.count {
                    if i < ary.count {
                        ary[i]++
                        if ary[i] < alphabet.count { break }
                        ary[i] = 0
                    } else {
                        return nil
                    }
                }
                return oldValue
            }
        }
    }
}