//
//  iEnigmaTests.swift
//  iEnigmaTests
//
//  Created by Leo Mehlig on 4/15/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit
import XCTest

class MacEnigmaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testEnigma() {
        let text = "aaaaa"
        let exResult = "ftzmg"
        
        //Setting up Enigma
        let enigma = Enigma(ref: .B, rotors: .I, .II, .III)
        
        //Encoding String
        let encodeStr = enigma.encodeText(text)
        
        //Checking Result
        XCTAssertEqual(encodeStr, exResult, "\(enigma)")
    }
    func testOffset() {
        //Encode Text & Expected Result
        let text = "aaaaa"
        let exResult = "iptoi"
        
        //Setting up Enigma
        let enigma = Enigma(ref: .B, rotors: .I, .II, .III)
        enigma.rotor(0)?.offsetPosition = 7
        enigma.rotor(0)?.rotorPositionLetter = "o"
        
        //Encoding String
        let encodeStr = enigma.encodeText(text)
        
        //Checking Result
        XCTAssertEqual(encodeStr, exResult, "\(enigma)")
    }
    
    func testRotorPosition() {
        //Encode Text & Expected Result
        let text = "helloworld"
        let exResult = "jamhxabhjz"
        
        //Setting up Enigma
        let enigma = Enigma(ref: .A, rotors: .III, .II, .I)
        enigma.rotor(0)?.rotorPositionLetter = "o"
        enigma.rotor(1)?.rotorPositionLetter = "f"
        enigma.rotor(2)?.rotorPositionLetter = "k"
        
        //Encoding String
        let encodeStr = enigma.encodeText(text)
        
        //Checking Result
        XCTAssertEqual(encodeStr, exResult, "\(enigma)")
        
    }
    
    func testPlugboard() {
        //Encode Text & Expected Result
        let text = "helloworld"
        let exResult = "pvdilpjnja"
        
        //Setting up Enigma
        let enigma = Enigma(ref: .A, rotors: .III, .II, .I)
        enigma.plugboard.pairs = [PlugboardPair("a","v"), PlugboardPair("d", "m"), PlugboardPair("f", "t"), PlugboardPair("h", "i"), PlugboardPair("k", "o"), PlugboardPair("p", "s"), PlugboardPair("q", "x"), PlugboardPair("r", "w")]
        enigma.rotor(0)?.rotorPositionLetter = "o"
        enigma.rotor(1)?.rotorPositionLetter = "f"
        enigma.rotor(2)?.rotorPositionLetter = "k"
        
        //Encoding String
        let encodeStr = enigma.encodeText(text)
        
        //Checking Result
        XCTAssertEqual(encodeStr, exResult, "\(enigma)")
    }
    
    func testEnigmaPerformence() {
        
        //Encode Text & Expected Result
        let text = "hallojedoxianerdankefrdiefreundlicheaufnahmeineuerteamichbinsehrangetanvonderstimmungderkulturunddermotivationundfreuemichaufeinsupererfolgreichesmiteuchichwerdeindenkommendenwocheninregelmssigenabstndenmeineerfahrungenmiteuchteilendamitwirauchdirektmiteinanderkommunizierenknnenmchteicheuchbittenmichbereurenskypeaccounteinzuladenichbineingrosserfanvoninstantmessagingundvideokommunikationdasverringertdiedistanzenundschafftmehrnheanbeimeinskypenameunterdemihrmichfindenknntkayingogrevevielegrssekay"
        let exResult = "fmjxqmysvsdttubnffatqqrcqcblmikdlqdavyiztrdxnhvdqmilbdcdgwchjurbzzfaakimrfqdibhghijdnilplgwqidjjpamwotjgurywrocwfecajnwfuducmcqdatazotkjmixyufypxchblqsyzcrkbryotfrmroganoouqymzuybxpfrkmdktdkuccbpxvfuayvpdiorgnhhjyaegvkgrsjqozswahprhvkaupzwxbjjkoazlppavqvlfzukgcbhixlmtgevohcnzlxoppmgqjjdcfxjeuegyadcbpalwnelultwifyrvabmqohxjrxhtygroyedscuvofdagdaluubolqxraliirzlrahaxovqmkpvurcflawtivumiudhontfrhzdcwtphiexigzxvjpnuagnelipvpgqlifmyfwjrkejwjjxngnrfguiouqwnygfhtuyzvqdxkmpfpmwdhkeurdsmeotbtczphlbcduhqf"
        measureBlock {
            //Setting up Enigma
            let enigma = Enigma(ref: .A, rotors: .III, .II, .I)
            enigma.plugboard.pairs = [PlugboardPair("a","v"), PlugboardPair("d", "m"), PlugboardPair("f", "t"), PlugboardPair("h", "i"), PlugboardPair("k", "o"), PlugboardPair("p", "s"), PlugboardPair("q", "x"), PlugboardPair("r", "w")]
            enigma.rotor(0)?.rotorPositionLetter = "o"
            enigma.rotor(1)?.rotorPositionLetter = "f"
            enigma.rotor(2)?.rotorPositionLetter = "k"
            enigma.rotor(0)?.offsetPosition = 7
            enigma.rotor(1)?.offsetPosition = 24
            enigma.rotor(2)?.offsetPosition = 10
            
            //Encoding String
            let encodeStr = enigma.encodeText(text, needsValidation: false)
            
            //Checking Result
            XCTAssertEqual(encodeStr, exResult, "\(enigma)")
        }
        
    }
    
    func testUnmatchingStringPerformence() {
        let testStr = "fmjxqmysvsdttubnffatqqrcqcblmikdlqdavyiztrdxnhvdqmilbdcdgwchjurbzzfaakimrfqdibhghijdnilplgwqidjjpamwotjgurywrocwfecajnwfuducmcqdatazotkjmixyufypxchblqsyzcrkbryotfrmroganoouqymzuybxpfrkmdktdkuccbpxvfuayvpdiorgnhhjyaegvkgrsjqozswahprhvkaupzwxbjjkoazlppavqvlfzukgcbhixlmtgevohcnzlxoppmgqjjdcfxjeuegyadcbpalwnelultwifyrvabmqohxjrxhtygroyedscuvofdagdaluubolqxraliirzlrahaxovqmkpvurcflawtivumiudhontfrhzdcwtphiexigzxvjpnuagnelipvpgqlifmyfwjrkejwjjxngnrfguiouqwnygfhtuyzvqdxkmpfpmwdhkeurdsmeotbtczphlbcduhqf"
        let testWord = "jedox"
        let bombe = Bombe()
        measureBlock {
            let t = bombe.completUnmatchingPartsOfText(testStr, toWord: testWord)
            
            XCTAssert(t.count == 406, "\(t)")
        }
    }
    
    func testCirclePerformence() {
        measureBlock {
            let con = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: "WETTERVORHERSAGEBISKAYA", decodedStr: "RWIVTYRESXBFOGKUHQBAISE")
        }
    }
    
    func testBombePlugboard() {
        let testText = "anmastervonwetterbericht"
        let enigma = Enigma(ref: .A, rotors: .I, .II, .III)
        enigma.plugboard.pairs = [PlugboardPair("a","v"), PlugboardPair("d", "m"), PlugboardPair("f", "t"), PlugboardPair("h", "i"), PlugboardPair("k", "o"), PlugboardPair("p", "s"), PlugboardPair("q", "x"), PlugboardPair("r", "w")]
        let encodedText = enigma.encodeText(testText)
        if let loops = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: testText, decodedStr: encodedText) {
            //measureBlock {
            let bombe = PlugboardBombe(enigma: Enigma(ref: .A, rotors: .I, .II, .III))
            XCTAssertNotNil(bombe.plugboardForLoops(loops, text: testText, enText: encodedText), "failed")
            
            
            // }
        }
    }
    
    func testBombePlugboardWrongPairs() {
        let testText = "helloworld"
        let enigma = Enigma(ref: .A, rotors: .I, .II, .III)
        enigma.plugboard.pairs = [PlugboardPair("l","v"), PlugboardPair("d", "m"), PlugboardPair("f", "t"), PlugboardPair("h", "i"), PlugboardPair("k", "o"), PlugboardPair("p", "s"), PlugboardPair("q", "x"), PlugboardPair("r", "w")]
        let encodedText = enigma.encodeText(testText)
        if let loops = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: testText, decodedStr: encodedText) {
            measureBlock {
                let bombe = PlugboardBombe(enigma: Enigma(ref: .A, rotors: .I, .II, .III))
                XCTAssertNotNil(bombe.plugboardForLoops(loops, text: testText, enText: encodedText), "failed")
            }
        }
    }
    
    func testStepBack() {
        let enigma = Enigma(ref: .A, rotors: .I, .II, .III)
        let startI: Character = "e"
        let startII: Character = "h"
        let startIII: Character = "y"
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
    
    
    func testLoopDeductionPerformance() {
        measureBlock {
            let testText = "wearethewatchersonthewall"
            let enigma = Enigma(ref: .A, rotors: .I, .II, .III)
            enigma.plugboard.pairs = [PlugboardPair("l","v"), PlugboardPair("d", "m"), PlugboardPair("f", "t"), PlugboardPair("h", "i"), PlugboardPair("k", "o"), PlugboardPair("p", "s"), PlugboardPair("q", "x"), PlugboardPair("r", "w")]
            let encodedText = enigma.encodeText(testText)
            let bombe = PlugboardBombe(enigma: Enigma(ref: .A, rotors: .I, .II, .III))
            if let con = PlugboardBombe.LoopCreater.loopConnectionsFrom(encodedStr: testText, decodedStr: encodedText) {
                println(bombe.plugboardForLoops(con, text: testText, enText: encodedText))
            }
        }
        
        
    }
    
    
    func stestBombePerformance() {
        measureBlock {
            let testText = "wearethewatchersonthewall"
            let enigma = Enigma(ref: .A, rotors: .I, .II, .III)
            enigma.rotor(0)?.rotorPositionLetter = "f"
            enigma.rotor(1)?.rotorPositionLetter = "q"
            enigma.rotor(2)?.rotorPositionLetter = "c"
            enigma.plugboard.pairs = [PlugboardPair("a","v"), PlugboardPair("d", "m"), PlugboardPair("f", "t"), PlugboardPair("h", "i"), PlugboardPair("k", "o"), PlugboardPair("p", "s"), PlugboardPair("q", "x"), PlugboardPair("r", "w")]
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
                    return bombe.plugboardForLoops(loops, text: testText, enText: encodedText)
                    
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
