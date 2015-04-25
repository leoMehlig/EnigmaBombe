//
//  Rotor.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import Foundation

struct RotorSetting: Printable {
    
    
    let input: [Int]
    let output: [Int]
    let turnover: UInt16
    var type: Rotor.RotorType?
    var offset = 0
    
    init(_ outp: [Int], turnover t: UInt16, offset: Int = 0) {
        
        output = outp
        var tempIn = [Int](count: 26, repeatedValue: 0)
        for (idx, pos) in enumerate(outp) {
            tempIn.replaceRange(pos..<pos+1, with: [idx])
        }
        input = tempIn
        turnover = t
    }
    
    init(type t: Rotor.RotorType, offset of: Int = 0) {
        switch t {
        case .I:
            self.init([4, 10, 12, 5, 11, 6, 3, 16, 21, 25, 13, 19, 14, 22, 24, 7, 23, 20, 18, 15, 0, 8, 1, 17, 2, 9], turnover: 17, offset: of)
        case .II:
            self.init([0, 9, 3, 10, 18, 8, 17, 20, 23, 1, 11, 7, 22, 19, 12, 2, 16, 6, 25, 13, 15, 24, 5, 21, 14, 4], turnover: 5, offset: of)
        case .III:
            self.init([1, 3, 5, 7, 9, 11, 2, 15, 17, 19, 23, 21, 25, 13, 24, 4, 8, 22, 6, 0, 10, 12, 20, 18, 16, 14], turnover: 22, offset: of)
        }
        type = t
    }
    
    var description: String {
        if let t = type {
            return "\(t) : \(input[offset]) - \(offset)"
        } else {
            var des = ""
            for char in output {
                des += String(char)
            }
            return "\(des) (turnover = \(turnover)) : \(input[offset]) - \(offset)"
        }
    }
    
}

class Rotor: Printable {
    enum RotorType: Int, Printable {
        case I = 0, II, III
        
        var description: String {
            switch self {
            case .I:
                return "I"
            case .II:
                return "II"
            case .III:
                return "III"
            }
        }
        static var allTypes: [RotorType]  = {
            var types = [RotorType]()
            while true {
                if let t = RotorType(rawValue: types.count) {
                    types.append(t)
                } else {
                    break
                }
            }
            return types
            }()
        
        static func possibleOrders(#numberOfRotors: Int) -> [[RotorType]] {
            var remainder = allTypes.count - numberOfRotors
            if remainder < 0 { remainder = 0 }
            return generatePossibleOrders(allTypes, remainder: remainder)
        }
        private static func generatePossibleOrders(values: [RotorType], remainder: Int) -> [[RotorType]] {
            var possibleOrders = [[RotorType]]()
            for (idx, val) in enumerate(values) {
                var newValues = values
                newValues.removeAtIndex(idx)
                if newValues.count > remainder {
                    for order in generatePossibleOrders(newValues, remainder: remainder) {
                        possibleOrders.append([val] + order)
                    }
                } else {
                    possibleOrders.append([val])
                }
                
            }
            return possibleOrders
        }
        
    }

    var rotorSetting: RotorSetting
    private var _rotorPosition = 0
    var startRotorPosition: Int = 0 {
        didSet {
            while startRotorPosition >= rotorSetting.input.count {
                startRotorPosition -= rotorSetting.input.count
            }
            while startRotorPosition < 0 {
                startRotorPosition += rotorSetting.input.count
            }
        }
    }
    var nextRotor: Rotor?
    var rotorPositionLetter: Character {
        get {
            return alphabet[startRotorPosition]
        }
        set {
            startRotorPosition = idxAlphabet[newValue] ?? 0
            _rotorPosition = startRotorPosition
        }
    }
    
    var rotorPosition: Int {
        get {
            return _rotorPosition
        }
        set {
            var newPosition = newValue
            while newPosition >= rotorSetting.input.count {
                newPosition -= rotorSetting.input.count
            }
            _rotorPosition = newPosition
        }
    }
    
    func resetRotor(andAdd add: Int = 0) {
        if let nextR = nextRotor {
            if add == 0 {
                _rotorPosition = startRotorPosition
                nextR.resetRotor()
                return
            }
            let turnover = Int(rotorSetting.turnover)
            var nextSteps = 0
            var stepsToGo = add
            var currentRotorPosition = startRotorPosition
            if startRotorPosition >= turnover && stepsToGo >= (rotorSetting.input.count - startRotorPosition) + turnover {
                nextSteps++
                stepsToGo -= ((rotorSetting.input.count - startRotorPosition) + turnover)
                currentRotorPosition = turnover
            } else if startRotorPosition < turnover && stepsToGo >= turnover - startRotorPosition {
                nextSteps++
                stepsToGo -= (turnover - startRotorPosition)
                currentRotorPosition = turnover
            } else {
                rotorPosition = startRotorPosition + add
                nextR.resetRotor()
                return
            }
            let steps = Int(stepsToGo/rotorSetting.input.count)
            nextSteps += steps
            rotorPosition = currentRotorPosition + (stepsToGo - (steps*rotorSetting.input.count))
            if nextR.rotorOrderNumber == 1 {
                let nextRTurnover = Int(nextR.rotorSetting.turnover)
                var nextStepsToGo = nextSteps
                while nextStepsToGo >= nextR.rotorSetting.input.count {
                    nextStepsToGo -= nextR.rotorSetting.input.count - 1
                    nextSteps++
                }
                if nextR.startRotorPosition > nextRTurnover - 1 && nextStepsToGo >= (nextR.rotorSetting.input.count - nextR.startRotorPosition) + nextRTurnover - 1 {
                    if nextSteps != (nextR.rotorSetting.input.count - nextR.startRotorPosition) + nextRTurnover - 1 || rotorPosition != turnover {
                        nextSteps++
                        nextStepsToGo -= ((rotorSetting.input.count - startRotorPosition) + turnover - 1)
                    }
                    
                } else if nextR.startRotorPosition <= nextRTurnover - 1 && nextStepsToGo >= nextRTurnover - 1 - nextR.startRotorPosition {
                    nextSteps++
                    nextStepsToGo -= ((rotorSetting.input.count - startRotorPosition) + turnover - 1)
                }
            
            }
            if nextSteps > 0 {
                
            }
            nextR.resetRotor(andAdd: nextSteps)
        } else {
            rotorPosition = startRotorPosition + add
        }
        
    }
    
    var offsetLetter: Character {
        get {
            return alphabet[rotorSetting.offset]
        }
        set {
            for (idx, char) in enumerate(alphabet) {
                if char == newValue {
                    rotorSetting.offset = idx
                    break
                }
            }
        }
        
    }
    
    var offsetPosition: Int {
        get {
            return rotorSetting.offset
        }
        set {
            var n = newValue
            while n < 0 {
                n += alphabet.count
            }
            rotorSetting.offset = n
        }
    }
    
    var rotorType: Rotor.RotorType? {
        return rotorSetting.type
    }
    typealias TurnoverClosur = (forward: Bool) -> Void
    var turnoverCallback: TurnoverClosur?
    var rotorOrderNumber: Int = 0
    
    init(settings: RotorSetting, orderNumber: Int, turnover: TurnoverClosur? = nil) {
        rotorSetting = settings
        rotorOrderNumber = orderNumber
        if let turnCall = turnover {
            turnoverCallback = turnCall
        }
    }
    
    convenience init(type: Rotor.RotorType, orderNumber: Int) {
        self.init(settings: RotorSetting(type: type), orderNumber: orderNumber)
    }
    
    func step() {
        _rotorPosition++
       // println(" \(rotorOrderNumber), \(_rotorPosition)")

        if _rotorPosition >= rotorSetting.input.count {
            _rotorPosition = 0
        }
        if _rotorPosition == Int(rotorSetting.turnover) {
            turnoverCallback?(forward: true)
          //  println("turn \(rotorOrderNumber), \(_rotorPosition)")
        }
    }
    
    func stepSecondRotorIfNeeded() {
        if _rotorPosition == Int(rotorSetting.turnover) - 1 {
            step()
            //println("extrastep")
        }
    }
    
    func stepBack() {
        if _rotorPosition == Int(rotorSetting.turnover) {
            turnoverCallback?(forward: false)
        }
        _rotorPosition--
        if _rotorPosition < 0 {
            _rotorPosition = rotorSetting.input.count - 1
        }
    }
    
    func stepBackSecondRotorIfNeeded() {
        if _rotorPosition == Int(rotorSetting.turnover) {
            stepBack()
        }
    }
    func encodePosition(i: Int) -> Int {
        var n = i + _rotorPosition - rotorSetting.offset
        while n < 0 {
            n += rotorSetting.output.count
        }
        while n >= rotorSetting.output.count {
            n -= rotorSetting.output.count
        }
        return rotorSetting.output[n] - _rotorPosition + rotorSetting.offset
        
    }
    
    func reverseEncodePosition(i: Int) -> Int {
        var n = i + _rotorPosition - rotorSetting.offset
        while n < 0 {
            n += rotorSetting.input.count
        }
        while n >= rotorSetting.input.count {
            n -= rotorSetting.input.count
        }
        return rotorSetting.input[n] - _rotorPosition + rotorSetting.offset
    }
    
    
    var description: String {
        return "\(rotorOrderNumber). \(rotorSetting) (Position: \(rotorPositionLetter))"
        
    }
}
