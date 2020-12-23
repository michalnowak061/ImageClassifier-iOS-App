//
//  CollectionViewCellExtensions.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 22/12/2020.
//

import UIKit

extension UICollectionViewCell {
    public func setRoundedCorners(cornerRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
