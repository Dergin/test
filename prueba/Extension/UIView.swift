//
//  UIView.swift
//  prueba
//
//  Created by Adrian on 23/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import UIKit

extension UIView {
    
    /*func animateConstraintWithDuration(duration: NSTimeInterval = 0.5, delay: NSTimeInterval = 0.0, options: UIViewAnimationOptions = nil, completion: ((Bool) -> Void)? = nil) {
     UIView.animateWithDuration(duration, delay:delay, options:options, animations: { [weak self] in
     self?.layoutIfNeeded() ?? ()
     }, completion: completion)
     }*/
    
    func animateConstraintWithDuration(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, options: UIView.AnimationOptions, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay:delay, options:options, animations: { [weak self] in
            self?.layoutIfNeeded() ?? ()
            }, completion: completion)
    }
    
    
    //
    // Inspectable - Design and layout for View
    // cornerRadius, borderWidth, borderColor
    //
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue > layer.frame.size.height ? floor(layer.frame.size.height/2) : newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}
