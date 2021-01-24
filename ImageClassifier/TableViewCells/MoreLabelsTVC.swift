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
            return (self.predictionLabel.text! as NSString).floatValue
        }
        set(newProgress) {
            self.predictionProgressBarShowProgress(CGFloat(newProgress))
        }
    }
    
    // MARK: -- Private function's
    private func predictionProgressBarShowProgress(_ progress: CGFloat) {
        self.predictionLabel.text = String(format: "%.0f", Double(progress * 100)) + "%"
    }
    
    // MARK: -- Public function's
    public func viewSetup() {

    }
    
    // MARK: -- IBOutlet's
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var predictionLabel: UILabel!
}
