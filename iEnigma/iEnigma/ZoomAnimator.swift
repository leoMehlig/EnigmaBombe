//
//  ZoomAnimator.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/26/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

protocol ZoombleViewRect {
    var zoomRect: CGRect? { get }
}

class ZoomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var back = false
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let sView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let dView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let rectToZoomTo: CGRect
        if let r = ((back ? dView : sView) as? ZoombleViewRect)?.zoomRect {
            rectToZoomTo = CGRect(x: r.minX + r.width / 4, y: r.minY + r.height / 4, width: r.width / 2, height: r.height / 2)
        } else {
            rectToZoomTo = CGRect(x: sView.view.bounds.width / 2 - 10, y: sView.view.bounds.height / 2 - 10, width: 20, height: 20)
        }
        let zoomRect = sView.view.convertRect(rectToZoomTo, toView: transitionContext.containerView())
        let scale = CGSize(width: sView.view.frame.width / zoomRect.width, height: sView.view.frame.height / zoomRect.height)
        let offset = CGPoint(x: sView.view.frame.midX - zoomRect.midX, y: sView.view.frame.midY - zoomRect.midY)
        
        if !back {
            dView.view.transform = CGAffineTransformMakeScale(zoomRect.width / dView.view.frame.width, zoomRect.height / dView.view.frame.height)
            dView.view.center = CGPoint(x: zoomRect.midX, y: zoomRect.midY)
            transitionContext.containerView().addSubview(dView.view)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                sView.view.transform = CGAffineTransform(a: scale.width, b: 0, c: 0, d: scale.height, tx: offset.x * scale.width, ty: offset.y * scale.height)
                dView.view.transform = CGAffineTransformMakeScale(1, 1)
                dView.view.frame.origin = CGPointZero
                }) { (fi) -> Void in
                    sView.view.transform = CGAffineTransformIdentity
                    transitionContext.completeTransition(fi)
            }
        } else {
            dView.view.transform = CGAffineTransform(a: scale.width, b: 0, c: 0, d: scale.height, tx: offset.x * scale.width, ty: offset.y * scale.height)
            transitionContext.containerView().insertSubview(dView.view, belowSubview: sView.view)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                dView.view.transform = CGAffineTransformIdentity
                dView.view.frame.origin = CGPointZero
                sView.view.transform = CGAffineTransformMakeScale(zoomRect.width / dView.view.frame.width, zoomRect.height / dView.view.frame.height)
                sView.view.center = CGPoint(x: zoomRect.midX, y: zoomRect.midY)
                sView.view.alpha = 0.0
                }) { (fi) -> Void in
                    sView.view.removeFromSuperview()
                    transitionContext.completeTransition(fi)
            }
        }
        
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
}
