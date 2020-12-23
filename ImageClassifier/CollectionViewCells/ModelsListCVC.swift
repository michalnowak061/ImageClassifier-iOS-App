//
//  ModelsListCell.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 17/12/2020.
//

import UIKit
import SwipeCellKit

class ModelsListCVC: SwipeCollectionViewCell {
    // MARK: -- Override variable's
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveLinear, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
        }
    }
    
    // MARK: -- Public variable's
    public let identifier: String = "ModelsListCVC"
    public var modelIcon: UIImage? {
        get {
            return self.modelIconImageView.image ?? nil
        }
        set(newIcon) {
            self.modelIconImageView.image = newIcon
        }
    }
    public var modelName: String {
        get {
            return self.modelNameLabel.text ?? ""
        }
        set(newName) {
            self.modelNameLabel.text = newName
        }
    }
    public var modelFileSize: String {
        get {
            return self.modelFileSizeLabel.text ?? ""
        }
        set(newSize) {
            self.modelFileSizeLabel.text = newSize
        }
    }
    public var modelCreateDate: String {
        get {
            return self.modelCreateDateLabel.text ?? ""
        }
        set(newDate) {
            self.modelCreateDateLabel.text = newDate
        }
    }
    
    // MARK: -- Public function's
    public func viewSetup() {
        self.setRoundedCorners(cornerRadius: 10)
        self.modelIconImageView.setRoundedCorners(cornerRadius: 10)
    }
    
    // MARK: -- IBOutlet's
    @IBOutlet weak var modelIconImageView: UIImageView!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var modelFileSizeLabel: UILabel!
    @IBOutlet weak var modelCreateDateLabel: UILabel!
}
