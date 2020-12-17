//
//  ModelDescriptionVC.swift
//  ImageClassifier
//
//  Created by Michał Nowak on 16/12/2020.
//

import UIKit

// MARK: -- ModelDescriptionVC class
class ModelDescriptionVC: UIViewController {
    private var modelName: String?
    private var modelMetadata: [String : String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    // MARK: -- Private method's
    private func updateView() {
        if let name = self.modelName {
            self.modelNameLabel.text = name
        }
        if let data = self.modelMetadata {
            self.modelDescriptionTextView.text = data["description"]
            self.modelAuthorTextView.text = data["author"]
            self.modelLicenseTextView.text = data["license"]
            self.modelVersionTextView.text = data["version"]
        }
    }
    // MARK: -- Public method's
    public func setModel(name n: String) {
        self.modelName = n
    }
    public func setModel(metadata md: [String : String]) {
        self.modelMetadata = md
    }
    // MARK: -- IBOutlet's
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var modelDescriptionTextView: UITextView!
    @IBOutlet weak var modelAuthorTextView: UITextView!
    @IBOutlet weak var modelLicenseTextView: UITextView!
    @IBOutlet weak var modelVersionTextView: UITextView!
}

extension ModelDescriptionVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
          let fixedWidth = textView.frame.size.width
          textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
          let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
          var newFrame = textView.frame
          newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
          textView.frame = newFrame
    }
}
