//
//  UIImageViewExtensions.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 22/12/2020.
//

import UIKit

extension UIImageView {
    public func setRoundedCorners(cornerRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
