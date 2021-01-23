//
//  UIViewExtensions.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 28/12/2020.
//

import UIKit

extension UIView {
    public func setRoundedCorners(cornerRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
