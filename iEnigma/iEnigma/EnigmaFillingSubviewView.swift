//
//  EnigmaSettingBaseView.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/20/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class EnigmaFillingSubviewView: UIView {

   
    override func layoutSubviews() {
        for v in self.subviews as! [UIView] {
            v.frame = bounds
        }
    }

}
