//
//  EnigmaConstants.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit
struct Constants {
    struct Design {
        
        static var BodyFont: UIFont {
            let fontSize = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).pointSize
            return UIFont(name: "American Typewriter", size: fontSize) ?? UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }
        struct Colors {
            static let Text = UIColor.whiteColor()
            static let Background = UIColor(red: 72/255, green: 71/255, blue: 75/255, alpha: 1)
            static let Foreground = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
            static let DarkForeground = UIColor(red: 61/255, green: 54/255, blue: 54/255, alpha: 1)
            static let Letter = UIColor(red: 1, green: 1, blue: 122/255, alpha: 1)
        }
    }
    struct Keyboard {
        static let backspaceCharacter: Character = "←"
        static let KeyMatrix: [[Character]] = [["Q", "W", "E", "R", "T", "Z", "U", "I", "O"], ["A", "S", "D", "F", "G", "H", "J", "K", Constants.Keyboard.backspaceCharacter], ["P", "Y", "X", "C", "V", "B", "N", "M", "L"]]
    }
}

struct EnigmaSettings {
    private struct Keys {
        static let rotorI = "r1"
        static let rotorII = "r2"
        static let rotorIII = "r3"
        static let reflector = "ref"
        static let plugboard = "plg"

    }
    
    private var userDefault: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    var rotorI: Int {
        get {
            return userDefault.objectForKey(Keys.rotorI) as? Int ?? 0
        }
        set {
            userDefault.setObject(newValue, forKey: Keys.rotorI)
        }
    }
    
    var rotorII: Int {
        get {
            return userDefault.objectForKey(Keys.rotorII) as? Int ?? 1
        }
        set {
            userDefault.setObject(newValue, forKey: Keys.rotorII)
        }
    }
    
    var rotorIII: Int {
        get {
            return userDefault.objectForKey(Keys.rotorIII) as? Int ?? 2
        }
        set {
            userDefault.setObject(newValue, forKey: Keys.rotorIII)
        }
    }
    
    var reflector: Int {
        get {
            return userDefault.objectForKey(Keys.reflector) as? Int ?? 1
        }
        set {
            userDefault.setObject(newValue, forKey: Keys.reflector)
        }
    }
    
    var plugboard: [(Character, Character)] {
        get {
            return (userDefault.objectForKey(Keys.plugboard) as? [Box<(Character, Character)>])?.map { $0.content } ?? []
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