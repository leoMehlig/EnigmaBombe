//
//  Bombe.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import Foundation

class Bombe {
    func decodeText(encodedText: String, guessedWords: [String]) -> (decodedText: String, usedEnigma: Enigma)? {
        let unmatchingWords = unmatchingWordsDictFromText(encodedText, forWords: guessedWords)
        
        
        return nil
    }
    
    //Unmacthing Words
    func unmatchingWordsDictFromText(text: String, forWords wordAry: [String]) -> [String: [String]] {
        var unmatchDict = [String: [String]]()
        for word in wordAry {
            let m = completUnmatchingPartsOfText(text, toWord: word)
            if m.count > 0 {
                unmatchDict[word] = m
            }
        }
        return unmatchDict
    }
    func completUnmatchingPartsOfText(text: String, toWord word: String) -> [String] {
        var matchingDecodedStrings = [String]()
        let textStr = NSString(string: text)
        textLoop: for idx in 0..<(count(text)-count(word)) {
            let p = text[idx..<idx+count(word)]
            for (i, c) in enumerate(p) {
                if c == word[i]{
                    continue textLoop
                }
            }
            matchingDecodedStrings.append(p)
        }
        return matchingDecodedStrings
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