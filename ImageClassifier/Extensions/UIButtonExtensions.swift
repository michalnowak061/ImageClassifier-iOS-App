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
}
