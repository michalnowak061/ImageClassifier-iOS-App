//
//  MoreLabelsTVC.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 25/12/2020.
//

import UIKit
import MBCircularProgressBar

class MoreLabelsTVC: UITableViewCell {
    // MARK: -- Override variable's
    
    // MARK: -- Private variable's
    
    // MARK: -- Public variable's
    public let identifier: String = "MoreLabelsTVC"
    public var labelName: String {
        get {
            return self.classLabel.text ?? ""
        }
        set(newName) {
            self.classLabel.text = newName
        }
    }
    public var predictionValue: Float {
        get {
            return Float(self.predictionProgressBar.value)
        }
        set(newProgress) {
            self.predictionProgressBarShowProgress(CGFloat(newProgress))
        }
    }
    
    // MARK: -- Private function's
    private func predictionProgressBarShowProgress(_ progress: CGFloat) {
        UIView.animate(withDuration: 5.0) {
            self.predictionProgressBar.value = progress * 100
        }
    }
    
    // MARK: -- Public function's
    public func viewSetup() {

    }
    
    // MARK: -- IBOutlet's
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var predictionProgressBar: MBCircularProgressBarView!
}
