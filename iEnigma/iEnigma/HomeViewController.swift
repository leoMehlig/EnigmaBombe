//
//  HomeViewController.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/26/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate, ZoombleViewRect {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    private var enigmaEmbededController: AboutViewController? {
        didSet {
            enigmaEmbededController?.titleString = Text.Enigma.Title
            enigmaEmbededController?.subtitle = Text.Enigma.Subtitle
            enigmaEmbededController?.subtitle2 = Text.Enigma.Subtitle2
            enigmaEmbededController?.body = Text.Enigma.Body
            enigmaEmbededController?.body2 = Text.Enigma.Body2
            let enigmaButton = EnigmaRotorSettingButton()
            enigmaButton.buttonText = "Enigma"
            enigmaButton.addTarget(self, action: "showEnigma:", forControlEvents: .TouchUpInside)
            enigmaEmbededController?.bottonContent = enigmaButton
            enigmaEmbededController?.barHeight = navigationController?.navigationBar.frame.maxY ?? 0
            
        }
    }
    private var meEmbededController: AboutViewController?  {
        didSet {
            meEmbededController?.titleString = Text.Me.Title
            meEmbededController?.subtitle = Text.Me.Subtitle
            meEmbededController?.subtitle2 = Text.Me.Subtitle2
            meEmbededController?.body = Text.Me.Body
            meEmbededController?.body2 = Text.Me.Body2
            meEmbededController?.bottonContent = UIImageView(image: UIImage(named: "leo_mehlig"))
            meEmbededController?.barHeight = navigationController?.navigationBar.frame.maxY ?? 0
            
        }
    }
    private var bombeEmbededController: AboutViewController?  {
        didSet {
            bombeEmbededController?.titleString = Text.Bombe.Title
            bombeEmbededController?.subtitle = Text.Bombe.Subtitle
            bombeEmbededController?.subtitle2 = Text.Bombe.Subtitle2
            bombeEmbededController?.body = Text.Bombe.Body
            bombeEmbededController?.body2 = Text.Bombe.Body2
            let bombeButton = BombeDrumButton()
            bombeButton.contentText = "Bombe"
            bombeButton.addTarget(self, action: "showBombe:", forControlEvents: .TouchUpInside)
            bombeEmbededController?.bottonContent = bombeButton
            bombeEmbededController?.barHeight = navigationController?.navigationBar.frame.maxY ?? 0
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        meEmbededController?.swipeUp()
        bombeEmbededController?.swipeUp()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        widthConstraint.constant = self.view.bounds.width
        
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        for (idx, vc) in enumerate([enigmaEmbededController, meEmbededController, bombeEmbededController]) {
            let s = view.bounds.width * CGFloat(idx)

            let offset = scrollView.contentOffset.x - s
            let shrink = view.bounds.width / 5
            if offset > shrink || offset < -shrink {
                if vc?.baseScrollView.contentOffset.y > 0 {
                    vc?.baseScrollView.setContentOffset(CGPointZero, animated: true)

                }
            }
            let up = view.bounds.width / 2
            if offset > up || offset < -up {
                if vc?.isVisable == true {
                    vc?.swipeUp()
                }
            } else if vc?.isVisable == false {
                vc?.swipeIn()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            switch id {
            case "enigmaEmbed":
                enigmaEmbededController = segue.destinationViewController as? AboutViewController
            case "meEmbed":
                meEmbededController = segue.destinationViewController as? AboutViewController
            case "bombeEmbed":
                bombeEmbededController = segue.destinationViewController as? AboutViewController
            case "enigmaPush":
                break
            case "bombePush":
                break
            default: break
            }
        }
    }
    
    func showEnigma(sender: EnigmaRotorSettingButton) {
        zoomRect = view.convertRect(sender.bounds, fromView: sender)
        performSegueWithIdentifier("enigmaPush", sender: sender)
    }
    
    func showBombe(sender: BombeDrumButton)  {
        zoomRect = view.convertRect(sender.bounds, fromView: sender)

        performSegueWithIdentifier("bombePush", sender: sender)
    }
    
    var zoomRect: CGRect?
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let an = ZoomAnimator()
        an.back = operation == .Pop
        return an
    }
    
    private struct Text {
        struct Enigma {
            static let Title = "The Enigma"
            static let Subtitle = ""
            static let Body = "The Enigma is an encryption device used by the Germans during World War II. It's basically a keyboard connected to 26 lights. By pressing a key electricity runs from that key through different components, these encrypt the letter into another letter. At the end another key lights up. The Enigma consists of three different encryption components: the plugboard, the rotors and the reflector. The plugboard consists of 26 holes, one for each letter, which can be connected via wires. If for example A and B are connected an A gets encrypted into a B and vise versa. \n After passing the plugboard the electricity runs through three rotors, of which the order can be changed. Each rotor again transforms a letter into another, but before each keystroke the first rotor gets turned one position forward. This makes that two same letters are not encrypted as two same letters. After the electricity went through all three rotors it gets encrypted by the reflector and gets sent back through all the other components. The reflector can be chosen out of three different types."
            static let Subtitle2 = "The Simulator"
            static let Body2 = "The simulator I wrote uses exactly the same encryption as the Enigma I. You can change all the settings by tapping the buttons at the top and type in the text with the keyboard. There were only capital letters and no wide spaces on the Enigma. The text will get encrypted into Enigma code. By tapping the cipher text you can copy or share it. Just give it a try by touching the gear wheel below."
        }
        
        struct Bombe {
            
            static let Title = "The Bombe"
            static let Subtitle = ""
            static let Body = "The Bombe is the “computer” that was able to break the Enigma code. Alan Turing and his team developed it during World War II in Bletchley Park, UK. With the Bombe they were able to read every radio message the Germans sent and with that they shortened the war by maybe two years. The simulator I wrote takes the cipher text and a word that could be in the encrypted text. The longer the word the better (at least 10 characters are recommended). Then it determines the plugboard wiring and the Enigma setting that would decode a part of the cipher text into the guessed word. \n For a start just encrypt a text with the Enigma and paste it into the Bombe simulator. For speed reasons just set the rotors and the reflector to be checked, for the other settings your current Enigma settings will be used. Touch the gear wheel to open to the Enigma and the circle to open the Bombe."
            static let Subtitle2 = ""
            static let Body2 = ""
        }
        
        struct Me {
            
            static let Title = "Leonard Mehlig"
            static let Subtitle = "This is me:"
            static let Body = "I'm a 17 years old school student from Germany. When I was 13 years old I started to teach myself iOS and Objective-C programming. I watched video tutorials, read books and most of all just coded something.\n In February 2014 I did a four weeks lasting internship in two software companies: \n \t - Synium Software (Mac and iOS - app development company from Germany - best known for MacFamilyTree), I developed a Mac app that fetched website content and compared it with older versions. \n \t - Jedox (Business Intelligence Company) were I also developed iOS apps. \n In summer 2014 I worked again for five weeks at Jedox and developed a Windows 8 App (Jedox Social Analytics). I'm still working there after school and during school breaks. At the moment I am working on the iOS version of the app which I made last summer, of cause completely written in Swift. The Jedox Social Analytics App is a tool to view and analyze all localized tweets from around the world. You can do a full text search on all tweets and view the results on a map. You can also view a graph with the amount of tweets over time or simply look at a top 100. Unfortunately the iOS app isn't released yet, but it will be out soon. \n Earlier I also started to make a music learning app which animates cords while playing. This project is still running."
            static let Subtitle2 = "About this app:"
            static let Body2 = "After watching the movie “The Imitation Game”, a movie about the breaking of the Nazi enigma code, I was very impressed by the work Alan Turing and his team had done. For better understanding the way they did it I wrote an Enigma simulator in Swift and after that a simulator of the device that broke the Enigma code, the Bombe. For more information about the Enigma and the Bombe and a working simulator of each one swipe left or right. \n I really hope you like my work and would be very happy to come over to America."
        }
    }
    


}

