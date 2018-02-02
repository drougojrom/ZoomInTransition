//
//  Animator.swift
//  TransitionProtorype
//
//  Created by Roman Ustiantcev on 06/11/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval
    var presenting: Bool
    var originFrame: CGRect
    var finalView: UIView? = nil
    
    init(duration: TimeInterval, presenting: Bool, originFrame: CGRect, finalView: UIView?) {
        self.duration = duration
        self.presenting = presenting
        self.originFrame = originFrame
        self.finalView = finalView
        
        super.init()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let middleView = SomeView.fromNib()
        let toView = transitionContext.view(forKey: .to)!
        
        var cellView = presenting ? middleView : transitionContext.view(forKey: .from)!
        var initialFrame = presenting ? originFrame : cellView.frame
        var finalFrame = presenting ? cellView.frame : originFrame
        
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor,
                                               y: yScaleFactor)
        if presenting {
            cellView.transform = scaleTransform
            cellView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            cellView.clipsToBounds = true
        }
        
        if presenting {
            
            containerView.addSubview(middleView)
            containerView.bringSubview(toFront: cellView)
            UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
                cellView.center = CGPoint(x: toView.bounds.width / 2, y: finalFrame.midY + 28)  // TODO: fix magic number (distance from top of screen to final view)
                cellView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            }) { (_) in
                UIView.animate(withDuration: self.duration, delay: 0.0, options: [.beginFromCurrentState], animations: {
                    cellView = self.presenting ? toView : transitionContext.view(forKey: .from)!
                    initialFrame = self.presenting ? self.originFrame : cellView.frame
                    finalFrame = self.presenting ? cellView.frame : self.originFrame
                    containerView.addSubview(toView)
                    containerView.bringSubview(toFront: cellView)
                }, completion: { (_) in
                    middleView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                })
            }
        } else {
            let newSomeView = finalView!
            containerView.addSubview(newSomeView)
            containerView.bringSubview(toFront: newSomeView)
            UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
                newSomeView.center = CGPoint(x: self.originFrame.midX, y: self.originFrame.midY)
                newSomeView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) { (_) in
                UIView.animate(withDuration: self.duration, delay: 0.0, options: [.beginFromCurrentState], animations: {
                    cellView = self.presenting ? toView : transitionContext.view(forKey: .from)!
                    initialFrame = self.presenting ? self.originFrame : cellView.frame
                    finalFrame = self.presenting ? cellView.frame : self.originFrame
                    containerView.addSubview(toView)
                    containerView.bringSubview(toFront: cellView)
                }, completion: { (_) in
                    middleView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                })
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
