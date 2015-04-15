//
//  PlugboardBombe.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import Foundation

class PlugboardBombe {
    private struct Deductions {
        private var dict = [Character: Character]()
        mutating func addPair(c1: Character, _ c2: Character) -> Bool {
            if let c = dict[c1] { if c != c2 { return false } }
            if let c = dict[c2] { if c != c1 { return false } }
            //if self.containsWrongPair(c1, c2) { return false }
            dict[c1] = c2
            dict[c2] = c1
            return true
        }
        var plugboardPairs: [PlugboardPair] {
            var pairs = [PlugboardPair]()
            for (char, otherChar) in dict {
                pairs.append(PlugboardPair(char, otherChar))
            }
            return pairs
        }
        
    }
    typealias Loop = (connections: [LoopConnection], indexRange: Range<Int>, closed: Bool)
    struct LoopConnection: Printable {
        let inputLetter: Character
        let outputLetter: Character
        let rotorPosition: Int
        init(inLetter: Character, outLetter: Character, position: Int) {
            inputLetter = inLetter
            outputLetter = outLetter
            rotorPosition = position
        }
        var description: String {
            return "\(inputLetter)-\(rotorPosition)-\(outputLetter)"
        }
        
    }
    
    let enigma: Enigma
    init(enigma e: Enigma) {
        enigma = e
    }
    
    private typealias AssumtionState = (loopIdx: Int, deductions: Deductions)
    private var assumtionStates = [AssumtionState]()
    private var startIdxs = [Int: Int]()
    func plugboardForLoops(loops: [Loop], text: String, enText: String) -> Plugboard? {
        enigma.rotor(0)?.resetRotor()
        var deductions = Deductions()
        var currentLoopIdx = 0
        while true {
            if currentLoopIdx >= loops.count { break }
            let (cons, _, _) = loops[currentLoopIdx]
            if let d = deductions.dict[cons.first!.inputLetter] {
                let (working, de) = deductionForLoop(cons, atIndex: 0, asLetter: d, pastDeductions: deductions)
                if working {
                    deductions = de
                    currentLoopIdx++
                    continue
                }
            } else if let (pairs, assumIdx) = assumtionForLoop(cons, pastDeductions: deductions, startIndex: startIdxs[currentLoopIdx] ?? 0) {
                assumtionStates.append((currentLoopIdx, deductions))
                startIdxs[currentLoopIdx] = assumIdx + 1
                deductions = pairs
                currentLoopIdx++
                continue
            } else {
                startIdxs[currentLoopIdx] = nil
            }
            
            if !assumtionStates.isEmpty {
                let lastAssum = assumtionStates.removeLast()
                currentLoopIdx = lastAssum.loopIdx
                deductions = lastAssum.deductions
                continue
            }
            return nil
            
        }
        if deductions.dict.isEmpty {
            return nil
        }
        return Plugboard(settings: deductions.plugboardPairs)
    }
    
    private func assumtionForLoop(connections: [LoopConnection], var pastDeductions: Deductions, startIndex: Int) -> (deductions: Deductions, assumention: Int)?  {
        if let con = connections.first {
            alphaLoop: for (idx, c) in enumerate(alphabet[startIndex..<alphabet.count]) {
                var deductions = pastDeductions
                if !deductions.addPair(con.inputLetter, c) {
                    continue alphaLoop
                }
                let (working, pairs) = deductionForLoop(connections, atIndex: 0, asLetter: c, pastDeductions: deductions)
                if working {
                    return (pairs, idx + startIndex)
                }
            }
        }
        
        
        return nil
    }
    private func deductionForLoop(connections: [LoopConnection], atIndex idx: Int, asLetter letter: Character, pastDeductions: Deductions) -> (working: Bool, pairs:Deductions) {
        let con = connections[idx]
        enigma.rotor(0)?.resetRotor(andAdd: con.rotorPosition)
        let c = enigma.encodeLetter(letter, usePlugboard: false)
        
        var deductions = pastDeductions
        if !deductions.addPair(con.outputLetter, c) {
            return (false, pastDeductions)
        }
        let newIdx = idx+1
        if connections.count > newIdx {
            return deductionForLoop(connections, atIndex: newIdx, asLetter: c, pastDeductions: deductions)
        } else {
            return (true, deductions)
        }
        
    }
    
    struct LoopCreater {
        
        private init() { }
        
        static func loopConnectionsFrom(#encodedStr: String, decodedStr: String) -> [Loop]? {
            var loops = [[LoopConnection]]()
            for (idx, encodedChar) in enumerate(encodedStr) {
                var connections: [LoopConnection] = [LoopConnection(inLetter: encodedChar, outLetter: decodedStr[idx], position: idx)]
                while true {
                    if let nextCon = nextConnectionForLoop(connections, encodedStr: encodedStr, decodedStr: decodedStr) {
                        connections.append(nextCon)
                        if connections.first?.inputLetter == nextCon.outputLetter {
                            var returnConnections = [LoopConnection]()
                            for (i, con) in enumerate(connections.reverse()) {
                                if i == 0 {
                                    returnConnections.append(con)
                                } else {
                                    if returnConnections.last?.inputLetter == con.outputLetter {
                                        returnConnections.append(con)
                                    }
                                }
                            }
                            returnConnections = returnConnections.reverse()
                            if returnConnections.first?.inputLetter == returnConnections.last?.outputLetter {
                                loops.append(returnConnections)
                            }
                            break
                        }
                    } else { break }
                    
                }
                
            }
            
            loops = removeDuplicatesFromLoops(loops)
            loops.sort{ $0.count > $1.count }
            var onePairLoops = [LoopConnection]()
            noLoop: for (idx, char) in enumerate(encodedStr) {
                for loop in loops {
                    for con in loop {
                        if idx == con.rotorPosition {
                            continue noLoop
                        }
                    }
                }
                onePairLoops.append(LoopConnection(inLetter:char, outLetter: decodedStr[idx], position: idx))
            }
            
            loops += removeDuplicatesFromLoops(joinOnePairLoops(onePairLoops)).sorted { $0.count > $1.count }
            
            
            if loops.count > 0 {
                let t = min(1, 5)
                return loops.map { (loop) -> Loop in
                    var maxP = loop.first!.rotorPosition
                    var minP = loop.last!.rotorPosition
                    for con in loop {
                        maxP = max(con.rotorPosition, maxP)
                        minP = min(con.rotorPosition, minP)
                    }
                    var closed = loop.first?.inputLetter == loop.last?.outputLetter
                    return (loop, minP...maxP, closed)
                }
            }
            return nil
        }
        
        private static func nextConnectionForLoop(oldConnections: [LoopConnection], encodedStr: String, decodedStr: String) -> LoopConnection? {
            charLoop: for (idx, encodedChar) in enumerate(encodedStr) {
                let decodedChar = decodedStr[idx]
                var nextCon: LoopConnection?
                for oldCon in oldConnections {
                    if idx == oldCon.rotorPosition { continue charLoop }
                    if nextCon != nil { continue }
                    if encodedChar == oldCon.outputLetter {
                        nextCon = LoopConnection(inLetter: encodedChar, outLetter: decodedChar, position: idx)
                    }
                    
                    if decodedChar == oldCon.outputLetter {
                        nextCon = LoopConnection(inLetter: decodedChar, outLetter: encodedChar, position: idx)
                    }
                }
                if nextCon != nil {
                    return nextCon
                }
            }
            return nil
        }
    
        private static func removeDuplicatesFromLoops(loops:[[LoopConnection]]) -> [[LoopConnection]] {
            var uniqueLoops = [[LoopConnection]]()
            loop: for loop in loops {
                for otherLoop in uniqueLoops {
                    var same = true
                    if otherLoop.count != loop.count {
                        same = false
                    } else {
                        for con in loop {
                            var sameCon = false
                            for otherCon in otherLoop {
                                if con.rotorPosition == otherCon.rotorPosition {
                                    sameCon = true
                                    break
                                }
                            }
                            if !sameCon {
                                same = false
                            }
                            
                        }
                        if same {
                            continue loop
                        }
                    }
                }
                uniqueLoops.append(loop)
            }
            return uniqueLoops
        }
        
        private static func joinOnePairLoops(pairs: [LoopConnection]) -> [[LoopConnection]] {
            var jointLoops = [[LoopConnection]]()
            for pair in pairs {
                var loop = [pair]
                var remaindingPairs = pairs
                while true {
                    var removeIdx: Int?
                    loop: for (idx, otherPair) in enumerate(remaindingPairs) {
                        for p in loop {
                            if p.rotorPosition == otherPair.rotorPosition { continue loop }
                        }
                        if loop.last?.outputLetter == otherPair.inputLetter {
                            loop.append(otherPair)
                        } else if loop.first?.inputLetter == otherPair.outputLetter {
                            loop.insert(otherPair, atIndex: 0)
                        } else if loop.last?.outputLetter == otherPair.outputLetter {
                            loop.append(LoopConnection(inLetter: otherPair.outputLetter, outLetter: otherPair.inputLetter, position: otherPair.rotorPosition))
                        } else if loop.first?.inputLetter == otherPair.inputLetter {
                            loop.insert(LoopConnection(inLetter: otherPair.outputLetter, outLetter: otherPair.inputLetter, position: otherPair.rotorPosition), atIndex: 0)
                        } else {
                            continue
                        }
                        removeIdx = idx
                        break
                    }
                    if let idx = removeIdx {
                        remaindingPairs.removeAtIndex(idx)
                    } else {
                        break
                    }
                }
                jointLoops.append(loop)
            }
            return jointLoops
        }
    }
    
    
}
