//
//  UIButtonExtensions.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 23/12/2020.
//

import UIKit

extension UIButton {
    public func setRoundedCorners(cornerRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    public func pressAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}
