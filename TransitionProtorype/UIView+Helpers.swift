//
//  UIView+Helpers.swift
//  TransitionProtorype
//
//  Created by Roman Ustiantcev on 06/11/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit

extension UIView {
    
    public func shakeViewForTimes(_ times: Int) {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0 )),
            NSValue(caTransform3D: CATransform3DMakeTranslation( 5, 0, 0 ))
        ]
        anim.autoreverses = true
        anim.repeatCount = Float(times)
        anim.duration = 7/100
        
        self.layer.add(anim, forKey: nil)
    }
    
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIView {
    
    class var nibName: String {
        let name = "\(self)".components(separatedBy: ".").first ?? ""
        return name
    }
    
    class var nib: UINib? {
        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
    
    class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = nibName
        }
        
        guard let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil) else {
            return nil
        }
        
        for v in nibViews {
            if let tog = v as? T {
                view = tog
            }
        }
        
        return view
    }
    
    class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        let v: T? = fromNib(nibNameOrNil: nibNameOrNil, type: T.self)
        return v!
    }
    
    class func fromNib(_ nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil: nibNameOrNil, type: self)
    }
    
}

extension UIView {
    // TODO: add iPhone X
    func scalable() -> UIView {
        switch UIScreen.main.bounds.height {
        case 480: //4
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.72)
            return self
        case 568: //5
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            return self
        case 736: //+
            self.transform = CGAffineTransform(scaleX: 1.104, y: 1.103)
            return self
        default: //6
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            return self
        }
    }
    
}
