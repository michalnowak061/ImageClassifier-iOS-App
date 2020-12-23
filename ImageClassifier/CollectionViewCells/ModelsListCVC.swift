//
//  ModelsListCell.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 17/12/2020.
//

import UIKit
import SwipeCellKit

class ModelsListCVC: SwipeCollectionViewCell {
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
