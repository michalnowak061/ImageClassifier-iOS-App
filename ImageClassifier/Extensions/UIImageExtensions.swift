//
//  UIImageExtensions.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 22/12/2020.
//

import UIKit

extension UIImage {
    public enum FileIconSize {
        case smallest
        case largest
    }
    
    public class func icon(forFileURL fileURL: URL, preferredSize: FileIconSize = .smallest) -> UIImage {
        let myInteractionController = UIDocumentInteractionController(url: fileURL)
        let allIcons = myInteractionController.icons

        // allIcons is guaranteed to have at least one image
        switch preferredSize {
        case .smallest:
            return allIcons.first ?? UIImage()
        case .largest:
            return allIcons.last ?? UIImage()
        }
    }
    
    public class func icon(forFileNamed fileName: String, preferredSize: FileIconSize = .smallest) -> UIImage {
        return icon(forFileURL: URL(fileURLWithPath: fileName), preferredSize: preferredSize)
    }
    
    public class func icon(forPathExtension pathExtension: String, preferredSize: FileIconSize = .smallest) -> UIImage {
        let baseName = "Generic"
        let fileName = (baseName as NSString).appendingPathExtension(pathExtension) ?? baseName
        return icon(forFileNamed: fileName, preferredSize: preferredSize)
    }
            
    private func imageWithInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
    
    public func imageWithInsets(insetDimen: CGFloat) -> UIImage {
        return imageWithInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
}
