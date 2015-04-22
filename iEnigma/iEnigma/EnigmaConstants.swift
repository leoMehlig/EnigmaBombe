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
        
        static var BoldFont: UIFont {
            let fontSize = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).pointSize
            return UIFont(name: "AmericanTypewriter-Bold", size: fontSize) ?? UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }
        struct Colors {
            static let Text = UIColor.whiteColor()
            static let Background = UIColor(red: 72/255, green: 71/255, blue: 75/255, alpha: 1)
            static let Foreground = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
            static let DarkForeground = UIColor(red: 61/255, green: 54/255, blue: 54/255, alpha: 1)
            static let Letter = UIColor(red: 1, green: 1, blue: 122/255, alpha: 1)
            static let Light = UIColor(red: 252/255, green: 254/255, blue: 107/255, alpha: 1)
        }
    }
    struct Keyboard {
        static let backspaceCharacter: Character = "←"
        static let KeyMatrix: [[Character]] = [["Q", "W", "E", "R", "T", "Z", "U", "I", "O"], ["A", "S", "D", "F", "G", "H", "J", "K", Constants.Keyboard.backspaceCharacter], ["P", "Y", "X", "C", "V", "B", "N", "M", "L"]]
    }
}


func CGRectFromSize(size: CGSize, centedInRect rect: CGRect) -> CGRect {
    if size.height >= rect.height && size.width >= rect.width { return rect }
    let y = (rect.height - size.height) / 2
    let x = (rect.width - size.width) / 2
    return CGRect(origin: CGPoint(x: x, y: y), size: size)
}

