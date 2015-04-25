//
//  iEnigmaTests.swift
//  iEnigmaTests
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit
import XCTest

class iEnigmaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testEnigma() {
        let text = "aaaaa".uppercaseString
        let exResult = "ftzmg".uppercaseString
        
        //Setting up Enigma
        let enigma = Enigma(ref: .B, rotors: .I, .II, .III)
        
        //Encoding String
        let encodeStr = enigma.encodeText(text)
        
        //Checking Result
        XCTAssertEqual(encodeStr, exResult, "\(enigma)")
    }
    func testOffset() {
        //Encode Text & Expected Result
        let text = "aaaaa".uppercaseString
        let exResult = "iptoi".uppercaseString
        
        //Setting up Enigma
        let enigma = Enigma(ref: .B, rotors: .I, .II, .III)
        enigma.rotor(0)?.offsetPosition = 6
        enigma.rotor(0)?.rotorPositionLetter = "O"
        
        //Encoding String
        let encodeStr = enigma.encodeText(text)
        
        //Checking Result
        XCTAssertEqual(encodeStr, exResult, "\(enigma)")
    }
    
    func testRotorPosition() {
        //Encode Text & Expected Result
        let text = "helloworld".uppercaseString
        let exResult = "jamhxabhjz".uppercaseString
        
        //Setting up Enigma
        let enigma = Enigma(ref: .A, rotors: .III, .II, .I)
        enigma.rotor(0)?.rotorPositionLetter = "O"
        enigma.rotor(1)?.rotorPositionLetter = "F"
        enigma.rotor(2)?.rotorPositionLetter = "K"
        
        //Encoding String
        let encodeStr = enigma.encodeText(text)
        
        //Checking Result
        XCTAssertEqual(encodeStr, exResult, "\(enigma)")
        
    }
    
    func testPlugboard() {
        //Encode Text & Expected Result
        let text = "helloworld".uppercaseString
        let exResult = "pvdilpjnja".uppercaseString
        
        //Setting up Enigma
        let enigma = Enigma(ref: .A, rotors: .III, .II, .I)
        enigma.plugboard.pairs = [PlugboardPair("A","V"), PlugboardPair("D", "M"), PlugboardPair("F", "T"), PlugboardPair("H", "I"), PlugboardPair("K", "O"), PlugboardPair("P", "S"), PlugboardPair("Q", "X"), PlugboardPair("R", "W")]
        enigma.rotor(0)?.rotorPositionLetter = "O"
        enigma.rotor(1)?.rotorPositionLetter = "F"
        enigma.rotor(2)?.rotorPositionLetter = "K"
        
        //Encoding String
        let encodeStr = enigma.encodeText(text)
        
        //Checking Result
        XCTAssertEqual(encodeStr, exResult, "\(enigma)")
    }
    
    func testEnigmaPerformence() {
        
        //Encode Text & Expected Result
        let text = "hallojedoxianerdankefrdiefreundlicheaufnahmeineuerteamichbinsehrangetanvonderstimmungderkulturunddermotivationundfreuemichaufeinsupererfolgreichesmiteuchichwerdeindenkommendenwocheninregelmssigenabstndenmeineerfahrungenmiteuchteilendamitwirauchdirektmiteinanderkommunizierenknnenmchteicheuchbittenmichbereurenskypeaccounteinzuladenichbineingrosserfanvoninstantmessagingundvideokommunikationdasverringertdiedistanzenundschafftmehrnheanbeimeinskypenameunterdemihrmichfindenknntkayingogrevevielegrssekay".uppercaseString
        let exResult = "fmjxqmysvsdttubnffatqqrcqcblmikdlqdavyiztrdxnhvdqmilbdcdgwchjurbzzfaakimrfqdibhghijdnilplgwqidjjpamwotjgurywrocwfecajnwfuducmcqdatazotkjmixyufypxchblqsyzcrkbryotfrmroganoouqymzuybxpfrkmdktdkuccbpxvfuayvpdiorgnhhjyaegvkgrsjqozswahprhvkaupzwxbjjkoazlppavqvlfzukgcbhixlmtgevohcnzlxoppmgqjjdcfxjeuegyadcbpalwnelultwifyrvabmqohxjrxhtygroyedscuvofdagdaluubolqxraliirzlrahaxovqmkpvurcflawtivumiudhontfrhzdcwtphiexigzxvjpnuagnelipvpgqlifmyfwjrkejwjjxngnrfguiouqwnygfhtuyzvqdxkmpfpmwdhkeurdsmeotbtczphlbcduhqf".uppercaseString
        measureBlock {
            //Setting up Enigma
            let enigma = Enigma(ref: .A, rotors: .III, .II, .I)
            enigma.plugboard.pairs = [PlugboardPair("A","V"), PlugboardPair("D", "M"), PlugboardPair("F", "T"), PlugboardPair("H", "I"), PlugboardPair("K", "O"), PlugboardPair("P", "S"), PlugboardPair("Q", "X"), PlugboardPair("R", "W")]
            enigma.rotor(0)?.rotorPositionLetter = "O"
            enigma.rotor(1)?.rotorPositionLetter = "F"
            enigma.rotor(2)?.rotorPositionLetter = "K"
            enigma.rotor(0)?.offsetPosition = 6
            enigma.rotor(1)?.offsetPosition = 23
            enigma.rotor(2)?.offsetPosition = 9
            
            //Encoding String
            let encodeStr = enigma.encodeText(text, needsValidation: false)
            
            //Checking Result
            XCTAssertEqual(encodeStr, exResult, "\(enigma)")
        }
        
    }
    
    func testUnmatchingString() {
        let text = "ABCDEF"
        let word = "WWDC"
        let unmatching = Bombe.completUnmatchingPartsOfText(text, toWord: word)
        XCTAssert(unmatching.count == 2, "\(unmatching)")
    }
    
    func testSingleUnmatchingString() {
        let text = "ABCD"
        let word = "WWDC"
        let unmatching = Bombe.completUnmatchingPartsOfText(text, toWord: word)
        XCTAssert(unmatching.count == 1, "\(unmatching)")
    }
    
    func testUnmatchingStringPerformence() {
        let testStr = "fmjxqmysvsdttubnffatqqrcqcblmikdlqdavyiztrdxnhvdqmilbdcdgwchjurbzzfaakimrfqdibhghijdnilplgwqidjjpamwotjgurywrocwfecajnwfuducmcqdatazotkjmixyufypxchblqsyzcrkbryotfrmroganoouqymzuybxpfrkmdktdkuccbpxvfuayvpdiorgnhhjyaegvkgrsjqozswahprhvkaupzwxbjjkoazlppavqvlfzukgcbhixlmtgevohcnzlxoppmgqjjdcfxjeuegyadcbpalwnelultwifyrvabmqohxjrxhtygroyedscuvofdagdaluubolqxraliirzlrahaxovqmkpvurcflawtivumiudhontfrhzdcwtphiexigzxvjpnuagnelipvpgqlifmyfwjrkejwjjxngnrfguiouqwnygfhtuyzvqdxkmpfpmwdhkeurdsmeotbtczphlbcduhqf"
        let testWord = "jedox"
        measureBlock {
            let t = Bombe.completUnmatchingPartsOfText(testStr.uppercaseString, toWord: testWord.uppercaseString)
            
            XCTAssert(t.count == 406, "\(t)")
        }
    }
    
    func testCirclePerformence() {
        measureBlock {
            let con = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: "WETTERVORHERSAGEBISKAYA", decodedStr: "RWIVTYRESXBFOGKUHQBAISE")
        }
    }
    
    func testBombePlugboard() {
        let testText = "anmastervonwetterbericht".uppercaseString
        let enigma = Enigma(ref: .A, rotors: .I, .II, .III)
        enigma.plugboard.pairs = [PlugboardPair("A","V"), PlugboardPair("D", "M"), PlugboardPair("F", "T"), PlugboardPair("H", "I"), PlugboardPair("K", "O"), PlugboardPair("P", "S"), PlugboardPair("Q", "X"), PlugboardPair("R", "W")]
        let encodedText = enigma.encodeText(testText)
        if let loops = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: testText, decodedStr: encodedText) {
            //measureBlock {
            let bombe = PlugboardBombe(enigma: Enigma(ref: .A, rotors: .I, .II, .III))
            XCTAssertNotNil(bombe.plugboardForLoops(loops), "failed")
            
            
            // }
        }
    }
    
    func testBombePlugboardWrongPairs() {
        let testText = ("helloworld").uppercaseString
        let enigma = Enigma(ref: .A, rotors: .I, .II, .III)
        enigma.plugboard.pairs = [PlugboardPair("L","V"), PlugboardPair("D", "M"), PlugboardPair("F", "T"), PlugboardPair("H", "I"), PlugboardPair("K", "O"), PlugboardPair("P", "S"), PlugboardPair("Q", "X"), PlugboardPair("R", "W")]
        let encodedText = enigma.encodeText(testText)
        if let loops = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: testText, decodedStr: encodedText) {
            measureBlock {
                let bombe = PlugboardBombe(enigma: Enigma(ref: .A, rotors: .I, .II, .III))
                XCTAssertNotNil(bombe.plugboardForLoops(loops), "failed")
            }
        }
    }
    
    func testStepBack() {
        let enigma = Enigma(ref: .A, rotors: .I, .II, .III)
        let startI: Character = "E"
        let startII: Character = "H"
        let startIII: Character = "Y"
        enigma.rotor(0)?.rotorPositionLetter = startI
        enigma.rotor(1)?.rotorPositionLetter = startII
        enigma.rotor(2)?.rotorPositionLetter = startIII
        for _ in 0...563 {
            enigma.rotor(0)?.step()
            enigma.rotor(1)?.stepSecondRotorIfNeeded()
        }
        for _ in 0...563 {
            enigma.rotor(0)?.stepBack()
            enigma.rotor(1)?.stepBackSecondRotorIfNeeded()
        }
        XCTAssert((startI == enigma.rotor(0)?.rotorPositionLetter && startII == enigma.rotor(1)?.rotorPositionLetter && startIII == enigma.rotor(2)?.rotorPositionLetter), "\(enigma)")
        
    }
    
    func testRotorOrders() {
        let order = Rotor.RotorType.possibleOrders(numberOfRotors: 3)
        
    }
    
    
    func testLoopDeductionPerformance() {
        measureBlock {
            let testText = ("wearethewatchersonthewall").uppercaseString
            let enigma = Enigma(ref: .A, rotors: .I, .II, .III)
            enigma.plugboard.pairs = [PlugboardPair("L","V"), PlugboardPair("D", "M"), PlugboardPair("F", "T"), PlugboardPair("H", "I"), PlugboardPair("K", "O"), PlugboardPair("P", "S"), PlugboardPair("Q", "X"), PlugboardPair("R", "W")]
            let encodedText = enigma.encodeText(testText)
            let bombe = PlugboardBombe(enigma: Enigma(ref: .A, rotors: .I, .II, .III))
            if let con = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: testText, decodedStr: encodedText) {
                println(bombe.plugboardForLoops(con))
            }
        }
        
        
    }
    
    
    func stestBombePerformance() {
        measureBlock {
            let testText = ("wearethewatchersonthewall").uppercaseString
            let enigma = Enigma(ref: .A, rotors: .I, .II, .III)
            enigma.rotor(0)?.rotorPositionLetter = "F"
            enigma.rotor(1)?.rotorPositionLetter = "Q"
            enigma.rotor(2)?.rotorPositionLetter = "C"
            enigma.plugboard.pairs = [PlugboardPair("A","V"), PlugboardPair("D", "M"), PlugboardPair("F", "T"), PlugboardPair("H", "I"), PlugboardPair("K", "O"), PlugboardPair("P", "S"), PlugboardPair("Q", "X"), PlugboardPair("R", "W")]
            let bombe = PlugboardBombe(enigma: enigma)
            let encodedText = enigma.encodeText(testText)
            if let loops = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: testText, decodedStr: encodedText) {
                for loop in loops {
                    println(loop)
                }
                println(encodedText)
                let rb = RotorBombe()
                rb.encodedString = encodedText
                rb.decodedString = testText
                rb.testRotors = { (e) in
                    let bombe = PlugboardBombe(enigma: e)
                    return bombe.plugboardForLoops(loops)
                    
                }
                while rb.running { }
            }
            
            
            
        }
    }
    
    func testResetRotorPosition() {
        let enigma = Enigma(ref: .A, rotors: .I, .II, .III)
        
        enigma.rotor(0)?.resetRotor(andAdd: 1_000)
        println(enigma)
        XCTAssert(12 == enigma.rotor(0)?.rotorPosition && 14 == enigma.rotor(1)?.rotorPosition && 2 == enigma.rotor(2)?.rotorPosition, "fail")
        
    }
    
    
    
}
