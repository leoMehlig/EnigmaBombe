//
//  TabBarViewController.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/22/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let enigmaTab = self.tabBar.items![0] as! UITabBarItem
        enigmaTab.image = UIImage(named: "EnimgaTapIcon")!.imageWithRenderingMode(.AlwaysOriginal)
        enigmaTab.selectedImage = UIImage(named: "EnimgaTapIconSelected")!.imageWithRenderingMode(.AlwaysOriginal)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be
    }
 
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
