//
//  ModelsListCell.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 17/12/2020.
//

import UIKit
import SwipeCellKit

// MARK: -- ModelsListCell
class ModelsListCVC: SwipeCollectionViewCell {
    // MARK: -- Public variable's
    let identifier: String = "ModelsListCVC"
    // MARK: -- Public method's
    public func set(modelName mn: String) {
        self.modelNameLabel.text = mn
    }
    // MARK: -- IBOutlet's
    @IBOutlet weak var modelNameLabel: UILabel!
}
