//: Playground - noun: a place where people can play

import Cocoa

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


let idxAlphabet: [Character: Int] = ["a": 0, "b": 1, "c": 2, "d": 3, "e": 4, "f": 5, "g": 6, "h": 7, "i": 8, "j": 9, "k": 10, "l": 11, "m": 12, "n": 13, "o": 14, "p": 15, "q": 16, "r": 17, "s": 18, "t": 19, "u": 20, "v": 21, "w": 22, "x": 23, "y": 24, "z": 25]

let setting = [ReflectorPair("f", "a"), ReflectorPair("v", "b"), ReflectorPair("p", "c"), ReflectorPair("j", "d"), ReflectorPair("i", "e"), ReflectorPair("o", "g"), ReflectorPair("y", "h"), ReflectorPair("r", "k"), ReflectorPair("z", "l"), ReflectorPair("x", "m"), ReflectorPair("w", "n"), ReflectorPair("t", "q"), ReflectorPair("u", "s")]
var temp = [Int](count: 26, repeatedValue: 0)
for p in setting {
    temp.replaceRange(p.position1..<p.position1+1, with: [p.position2])
    temp.replaceRange(p.position2..<p.position2+1, with: [p.position1])
    
}
temp
