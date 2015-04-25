//
//  Bombe.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import Foundation

protocol BombeCompletionDelegate: class {
    func completedAll()
    func completedWord(word: Bombe.StringWithLocation)
    func completedRotorOrder(order: [Rotor.RotorType], forWord: Bombe.StringWithLocation)
    func completedReflector(ref: Reflector.ReflectorType, forRotorOrder: [Rotor.RotorType], forWord: Bombe.StringWithLocation)
    func shouldContinueAfterFindingEnigma(enigma: Enigma) -> Bool
    func stopped()
    func progressDidChange(newProgress: Int)
}

class Bombe {
    typealias StringWithLocation = (String, Int)
    class func completUnmatchingPartsOfText(text: String, toWord word: String) -> [StringWithLocation] {
        if word.isEmpty { return [] }
        var matchingDecodedStrings = [StringWithLocation]()
        textLoop: for idx in 0...(count(text)-count(word)) {
            let p = text[idx..<idx+count(word)]
            for (i, c) in enumerate(p) {
                if c == word[i]{
                    continue textLoop
                }
            }
            matchingDecodedStrings.append((p, idx))
        }
        return matchingDecodedStrings
    }
    
    let rotorSequence: RotorSequence
    let reflectorSequnce: ReflectorSequence
    let positionSequence: PositionOffsetSequence
    let offsetSequence: PositionOffsetSequence
    
    lazy var totalCount: Int = 0
    let progressQueue: NSOperationQueue = {
        let q = NSOperationQueue()
        q.qualityOfService = NSQualityOfService.UserInitiated
        return q
        }()
    private var currentCount: Int = 0 {
        didSet {
            if currentCount >= Int(nextCount) {
                nextCount += percentCount
                self.postProgress()
            }
        }
    }
    private var percentCount: Double = 0
    private var nextCount: Double = 0
    private func postProgress() {
        if currentCount > 0 && percentCount > 0 {
            delegate?.progressDidChange(Int(Double(currentCount) / percentCount))
        }
    }
    
    init(rotor: Bool, reflector: Bool, position: Bool, offset: Bool) {
        rotorSequence = RotorSequence(onlySetting: !rotor)
        reflectorSequnce = ReflectorSequence(onlySetting: !reflector)
        positionSequence = PositionOffsetSequence(onlySettingValue: !position ? EnigmaSettings.rotorPositions : nil)
        offsetSequence = PositionOffsetSequence(onlySettingValue: !offset ? EnigmaSettings.rotorOffset : nil)
    }
    
    weak var delegate: BombeCompletionDelegate?
    
    private var queue: NSOperationQueue  {
        let q = NSOperationQueue()
        q.qualityOfService = NSQualityOfService.Utility
        return q
    }
    var stopped = true
    
    func startBombeWithWord(word: String, decryptedWords: [StringWithLocation]) {
        queue.addOperationWithBlock {
            self.totalCount = decryptedWords.count * self.rotorSequence.count * self.reflectorSequnce.count * self.positionSequence.count * self.offsetSequence.count
            self.nextCount = Double(self.totalCount) / 100
            self.percentCount = self.nextCount
            self.currentCount = 0
            self.stopped = false
            for (deWord, deLocation) in decryptedWords {
                if let loops = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: word, decodedStr: deWord) {
                    for rotorOrder in self.rotorSequence {
                        for ref in self.reflectorSequnce {
                            let enigma = Enigma(ref: ref, rotors: rotorOrder)
                            for pos in self.positionSequence {
                                for (idx, p) in enumerate(pos) {
                                    enigma.rotor(idx)?.startRotorPosition = p
                                }
                                for off in self.offsetSequence {
                                    if self.stopped {
                                        self.delegate?.stopped()
                                        return
                                    }
                                    for (idx, o)  in enumerate(off) {
                                        enigma.rotor(idx)?.offsetPosition = o
                                    }
                                    let bombe = PlugboardBombe(enigma: enigma)
                                    if let plugboard = bombe.plugboardForLoops(loops) {
                                        enigma.plugboard = plugboard
                                        self.stopped = !self.resetEnigmaToRightPosition(enigma, stringLocation: (deWord, deLocation))
                                    }
                                    self.currentCount++
                                }
                            }
                            self.delegate?.completedReflector(ref, forRotorOrder: rotorOrder, forWord: (deWord, deLocation))
                        }
                        self.delegate?.completedRotorOrder(rotorOrder, forWord:  (deWord, deLocation))
                    }
                }
                self.delegate?.completedWord((deWord, deLocation))
            }
            self.delegate?.completedAll()
            
        }
    }
    
    func resetEnigmaToRightPosition(enigma: Enigma, stringLocation: StringWithLocation) -> Bool {
        println(enigma)
        println(stringLocation)
        enigma.resetRotors()
        for _ in 0..<stringLocation.1 {
            enigma.rotor(0)?.stepBack()
            enigma.rotor(1)?.stepBackSecondRotorIfNeeded()
        }
        for rotor in enigma.rotors {
            rotor.startRotorPosition = rotor.rotorPosition
        }
        return delegate?.shouldContinueAfterFindingEnigma(enigma) ?? true
    }
}


extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let subStart = advance(self.startIndex, r.startIndex, self.endIndex)
            let subEnd = advance(subStart, r.endIndex - r.startIndex, self.endIndex)
            return self.substringWithRange(Range(start: subStart, end: subEnd))
        }
    }
    
    subscript (idx: Int) -> Character {
        get {
            let s = self[idx..<idx+1]
            for c in s { return c }
            return "x"
        }
    }
}