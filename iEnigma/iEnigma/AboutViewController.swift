//
//  AboutViewController.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/26/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = titleString
        }
    }
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    @IBOutlet weak var subtitle2Label: UILabel! {
        didSet {
            subtitle2Label.text = subtitle2
        }
    }
    @IBOutlet weak var bodyLabel: UILabel! {
        didSet {
            bodyLabel.text = body
        }
    }
    @IBOutlet weak var body2Label: UILabel! {
        didSet {
            body2Label.text = body2
        }
    }
    @IBOutlet weak var bottomContentView: EnigmaFillingSubviewView! {
        didSet {
            if let content = bottonContent {
                bottomContentView.addSubview(content)
            }
        }
    }
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trainlingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var baseScrollView: UIScrollView!
    
    var barHeight: CGFloat = 0
    var titleString: String?
    var subtitle: String?
    var subtitle2: String?
    var body: String?
    var body2: String?
    var bottonContent: UIView?
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setLabelMaxWidthforWidth(view.bounds.width)
        self.scrollViewDidScroll(self.baseScrollView)
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransitionInView(view, animation: { _ in
            self.setLabelMaxWidthforWidth(size.width)
            }, completion: { _ in })
    }
    
    func setLabelMaxWidthforWidth(width: CGFloat) {
        bodyLabel.preferredMaxLayoutWidth = width - 140
        body2Label.preferredMaxLayoutWidth = width - 140
        view.layoutIfNeeded()
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let margin = max(50 - scrollView.contentOffset.y / 6, 20)
        scrollView.layer.cornerRadius = max(margin - 10, 0)
        leadingConstraint?.constant = margin
        trainlingConstraint?.constant = margin
        if isVisable {
            topConstraint?.constant = max(50 + barHeight - scrollView.contentOffset.y / 6, 0)
            bottomConstraint?.constant = max(25 - scrollView.contentOffset.y, 0)
        }
        self.view.layoutIfNeeded()

    }
    

    var isVisable = true
    func swipeUp() {
        topConstraint.constant = -view.bounds.height
        bottomConstraint.constant = view.bounds.height
        isVisable = false
        UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { fi in
                if fi {
                    self.baseScrollView.layer.cornerRadius = 40
                }
        }
    }
    
    func swipeIn() {
        baseScrollView.contentOffset = CGPointZero
        bottomConstraint.constant = 25
        topConstraint.constant = 50 + barHeight
        isVisable = true
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}
