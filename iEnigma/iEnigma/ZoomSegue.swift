//
//  BombeDrumSegue.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/24/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class ZoomSegue: UIStoryboardSegue {
    var rectToZoomTo: CGRect?
    override func perform() {
        let sView = self.sourceViewController as! UIViewController
        let dView = self.destinationViewController as! UIViewController
        let zoomRect = rectToZoomTo ?? CGRect(x: sView.view.bounds.width / 2 - 10, y: sView.view.bounds.height / 2 - 10, width: 20, height: 20)
        
        let scale = CGSize(width: sView.view.frame.width / zoomRect.width, height: sView.view.frame.height / zoomRect.height)
        dView.view.transform = CGAffineTransformMakeScale(zoomRect.width / dView.view.frame.width, zoomRect.height / dView.view.frame.height)
        dView.view.center = CGPoint(x: zoomRect.midX, y: zoomRect.midY)
        sView.view.addSubview(dView.view)
        let offset = CGPoint(x: sView.view.frame.midX - zoomRect.midX, y: sView.view.frame.midY - zoomRect.midY)
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            sView.view.transform = CGAffineTransform(a: scale.width, b: 0, c: 0, d: scale.height, tx: offset.x * scale.width, ty: offset.y * scale.height)
            
            }) { (fi) -> Void in
                dView.view.transform = CGAffineTransformMakeScale(1, 1)
                if let nav = sView.navigationController {
                    nav.pushViewController(dView, animated: false)
                } else {
                    sView.presentViewController(dView, animated: false, completion: nil)
                }
                dView.view.removeFromSuperview()
        }
        
    }
}
