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
    
    init(duration: TimeInterval, presenting: Bool, originFrame: CGRect) {
        self.duration = duration
        self.presenting = presenting
        self.originFrame = originFrame
        
        super.init()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        var toView: UIView = SomeView.fromNib()
        
        var cellView = presenting ? toView : transitionContext.view(forKey: .from)!
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
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: cellView)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
            cellView.center = CGPoint(x: 187.5, y: finalFrame.midY + 28)
            cellView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            
        }) { (_) in
            UIView.animate(withDuration: self.duration, delay: 0.0, options: [.beginFromCurrentState], animations: {
                toView = transitionContext.view(forKey: .to)!
                cellView = self.presenting ? toView : transitionContext.view(forKey: .from)!
                initialFrame = self.presenting ? self.originFrame : cellView.frame
                finalFrame = self.presenting ? cellView.frame : self.originFrame
                containerView.addSubview(toView)
                containerView.bringSubview(toFront: cellView)
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
